//! Development-only generation of pinned report, feed, notification and SDL models.
use crate::{
    GenerationError,
    checkout::{git, verify_pinned},
    clients::pascal,
    escape_pointer,
    models::{self, visit_schema},
    unescape_pointer,
};
use serde::Deserialize;
use serde_json::{Value, json};
use std::{
    collections::{BTreeMap, BTreeSet},
    fs,
    path::{Path, PathBuf},
    process::Command,
};

#[derive(Debug, Deserialize)]
pub struct Source {
    pub family: String,
    pub module: String,
    pub path: String,
}

pub fn sources() -> Vec<Source> {
    serde_json::from_str(include_str!("../supplemental-sources.json")).expect("audited inventory")
}

pub const PATCHES: &[(&str, &[u8])] = &[
    (
        "any_offer_changed",
        include_bytes!("../../../lib/generator/patches/any_offer_changed.json"),
    ),
    (
        "b2b_any_offer_changed",
        include_bytes!("../../../lib/generator/patches/b2b_any_offer_changed.json"),
    ),
    (
        "pricing_health",
        include_bytes!("../../../lib/generator/patches/pricing_health.json"),
    ),
    (
        "fee_promotion",
        include_bytes!("../../../lib/generator/patches/fee_promotion.json"),
    ),
];

/// Render every supplemental schema. No schema fetching or source writes occur.
/// SDL conversion needs development Ruby/Bundler and the locked graphql gem.
pub fn generate_supplemental(
    checkout_root: &Path,
    revision: &str,
) -> Result<BTreeMap<PathBuf, String>, GenerationError> {
    if revision.contains(['\n', '\r']) {
        return Err(GenerationError("revision must be a single line".into()));
    }
    let mut output = BTreeMap::new();
    let mut errors = Vec::new();
    let mut families: BTreeMap<String, Vec<String>> = BTreeMap::new();
    for source in sources() {
        let result = (|| {
            let definitions = if source.family == "data_kiosk" {
                graphql_definitions(&checkout_root.join(&source.path))?
            } else {
                json_definitions(
                    checkout_root,
                    &source.path,
                    match source.family.as_str() {
                        "reports" => "Report",
                        "feeds" => "Feed",
                        _ => "Notification",
                    },
                    notification_patch(&source)?,
                )?
            };
            let notice = format!("{}{}", crate::notice(&source.path), definitions.notice);
            Ok::<_, GenerationError>(format!("{notice}{}", render(definitions)?))
        })();
        let result = match result {
            Ok(result) => result,
            Err(error) => {
                errors.push(format!("{}: {error}", source.path));
                continue;
            }
        };
        output.insert(
            Path::new("crates/peddler/src")
                .join(&source.family)
                .join(format!("{}.rs", source.module)),
            result,
        );
        families
            .entry(source.family)
            .or_default()
            .push(source.module);
    }
    if !errors.is_empty() {
        return Err(GenerationError(errors.join("\n")));
    }
    for (family, modules) in families {
        let names = modules.iter().map(|name| quote::format_ident!("{name}"));
        output.insert(
            Path::new("crates/peddler/src").join(&family).join("mod.rs"),
            format!(
                "{}{}",
                crate::notice(&format!("all {family} schemas")),
                crate::format_source(&quote::quote!(#(pub mod #names;)*).to_string())?
            ),
        );
    }
    Ok(output)
}

/// A notification's patch, with its name.
fn notification_patch(source: &Source) -> Result<Option<(&'static str, Value)>, GenerationError> {
    if source.family != "notifications" {
        return Ok(None);
    }
    PATCHES
        .iter()
        .find(|(name, _)| *name == source.module)
        .map(|(name, bytes)| Ok((*name, serde_json::from_slice(bytes)?)))
        .transpose()
}

/// A source's schemas and what rendering them needs besides.
#[derive(Default)]
pub struct Definitions {
    pub schemas: Value,
    /// Lines for the generated file's header on how the source was repaired
    notice: String,
    /// Typify can't generate the tax eligibility payload's `contains`: its messages
    /// must have an en-US entry.
    contains_en_us: bool,
    /// The enums that must refuse the fields their feed operation forbids, each with
    /// those fields by operation
    feed_guards: Vec<(String, Value)>,
}

pub fn graphql_definitions(source: &Path) -> Result<Definitions, GenerationError> {
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    let output = Command::new("bundle")
        .current_dir(&root)
        .args(["exec", "ruby"])
        .arg(root.join("tools/graphql/convert.rb"))
        .arg(source.canonicalize()?)
        .output()?;
    if !output.status.success() {
        return Err(GenerationError(format!(
            "SDL conversion requires bundle install: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        )));
    }
    Ok(Definitions {
        schemas: models::normalize_definitions(&serde_json::from_slice(&output.stdout)?)?,
        ..Definitions::default()
    })
}

/// Resolve schemas before Typify sees them, retaining typed local reference targets.
/// JSON patch runs after notification root resolution, matching the Ruby generator.
pub fn json_definitions(
    checkout: &Path,
    source: &str,
    root_type: &str,
    patch: Option<(&str, Value)>,
) -> Result<Definitions, GenerationError> {
    let path = safe_source(checkout, Path::new(source))?;
    let mut doc: Value = serde_json::from_slice(&fs::read(&path)?)?;
    let mut notice = String::new();
    if repair_shipment_schema(checkout, source, &mut doc)? {
        notice.push_str("// Missing upstream definitions repaired with pinned tracking_2026-01-30.json\n// and the established notification envelope. Envelope requiredness is conservative;\n// unknown object fields are retained. See tools/graphql/README.md.\n\n");
    }
    let contains_en_us = take_eligibility_contains(source, &mut doc)?;
    if let Some(reference) = doc
        .get("$ref")
        .or_else(|| doc.get("#ref"))
        .and_then(Value::as_str)
        && let Some(pointer) = reference.strip_prefix('#')
    {
        let mut root = doc
            .pointer(pointer)
            .cloned()
            .ok_or_else(|| GenerationError(format!("unresolved root reference {reference}")))?;
        if let Some(definitions) = doc.get("definitions") {
            root["definitions"] = definitions.clone();
        }
        doc = root;
    }
    if let Some((name, patch)) = patch {
        apply_patch(&mut doc, &patch)?;
        notice.push_str(&format!("// Patch: lib/generator/patches/{name}.json\n\n"));
    }
    let mut resolver = Resolver {
        checkout,
        docs: BTreeMap::from([(path.clone(), doc.clone())]),
        definitions: BTreeMap::new(),
        names: BTreeMap::new(),
        feed_guards: Vec::new(),
    };
    // Pre-register all declared definitions so unreferenced definitions survive.
    if let Some(definitions) = doc.get("definitions").and_then(Value::as_object) {
        for name in definitions.keys() {
            resolver.reference(&path, &format!("#/definitions/{}", escape_pointer(name)))?;
        }
    }
    doc.as_object_mut()
        .ok_or_else(|| GenerationError("root schema must be an object".into()))?
        .remove("definitions");
    doc.as_object_mut().unwrap().remove("title");
    resolver.walk(&mut doc, &path)?;
    if resolver.definitions.contains_key(root_type) {
        // If a source declares its root under the same name, retain that model.
        if resolver.definitions[root_type] != doc {
            return Err(GenerationError(format!("root type collision: {root_type}")));
        }
    } else {
        resolver.definitions.insert(root_type.into(), doc);
    }
    let mut schemas = models::normalize_definitions(&json!({"definitions":resolver.definitions}))?;
    disambiguate_titles(&mut schemas);
    // Typify names an enum after its schema's title. The root has none and gets the root type.
    let feed_guards = resolver.feed_guards.into_iter().map(|(title, forbidden)| {
        let name = title.map_or_else(|| root_type.to_owned(), |title| pascal(&title));
        (name, forbidden)
    });
    Ok(Definitions {
        schemas,
        notice,
        contains_en_us,
        feed_guards: feed_guards.collect(),
    })
}

fn safe_source(checkout: &Path, source: &Path) -> Result<PathBuf, GenerationError> {
    let root = checkout.canonicalize()?;
    let path = checkout.join(source).canonicalize()?;
    if !path.starts_with(root.join("schemas")) {
        return Err(GenerationError(
            "reference escapes supplemental schemas".into(),
        ));
    }
    Ok(path)
}

struct Resolver<'a> {
    checkout: &'a Path,
    docs: BTreeMap<PathBuf, Value>,
    definitions: BTreeMap<String, Value>,
    names: BTreeMap<(PathBuf, String), String>,
    /// The title of each schema whose feed branches were expanded, with the fields
    /// each operation forbids
    feed_guards: Vec<(Option<String>, Value)>,
}

impl Resolver<'_> {
    fn reference(&mut self, current: &Path, reference: &str) -> Result<String, GenerationError> {
        let (file, pointer) = reference.split_once('#').unwrap_or((reference, ""));
        let path = if file.is_empty() {
            current.to_owned()
        } else {
            if file.contains("://") {
                return Err(GenerationError(
                    "network schema references are forbidden".into(),
                ));
            }
            let relative = current.parent().unwrap().join(file);
            safe_source(self.checkout, &relative)?
        };
        let key = (path.clone(), pointer.into());
        if let Some(name) = self.names.get(&key) {
            return Ok(name.clone());
        }
        if let std::collections::btree_map::Entry::Vacant(entry) = self.docs.entry(path.clone()) {
            if self.checkout.join(".git").exists() {
                let root = self.checkout.canonicalize()?;
                let relative = path
                    .strip_prefix(&root)
                    .map_err(|error| GenerationError(error.to_string()))?
                    .to_str()
                    .ok_or_else(|| GenerationError("schema path must be UTF-8".into()))?;
                // `verify_sources` has shown every audited source tracked and unmodified.
                if !sources().iter().any(|source| source.path == relative) {
                    return Err(GenerationError(format!(
                        "reference outside audited source inventory: {relative}"
                    )));
                }
            }
            entry.insert(serde_json::from_slice(&fs::read(&path)?)?);
        }
        let mut target = self.docs[&path]
            .pointer(pointer)
            .cloned()
            .ok_or_else(|| GenerationError(format!("unresolved reference {reference}")))?;
        let preferred = pointer
            .strip_prefix("/definitions/")
            .filter(|name| !name.contains('/'))
            .map(unescape_pointer)
            .unwrap_or_else(|| format!("Referenced{}", self.names.len()));
        let name = if self.names.values().any(|name| *name == preferred) {
            format!("Referenced{}", self.names.len())
        } else {
            preferred
        };
        self.names.insert(key, name.clone());
        if let Some(node) = target.as_object_mut() {
            node.remove("definitions");
            node.remove("title");
        }
        self.walk(&mut target, &path)?;
        self.definitions.insert(name.clone(), target);
        Ok(name)
    }

    fn walk(&mut self, schema: &mut Value, current: &Path) -> Result<(), GenerationError> {
        let Some(node) = schema.as_object_mut() else {
            return Ok(());
        };
        if let Some(forbidden) = expand_feed_branches(node)? {
            let title = node.get("title").and_then(Value::as_str);
            self.feed_guards.push((title.map(str::to_owned), forbidden));
        }
        if node.get("additionalProperties") == Some(&Value::Bool(true)) {
            node.insert("additionalProperties".into(), json!({}));
        }
        // Amazon B2B/PricingHealth use a singleton items tuple for homogeneous
        // lists, explicitly with additionalItems:true. Preserve genuine tuples.
        if node.get("type").and_then(Value::as_str) == Some("array")
            && node.get("additionalItems") == Some(&Value::Bool(true))
            && node
                .get("items")
                .and_then(Value::as_array)
                .is_some_and(|items| items.len() == 1)
        {
            let item = node
                .get_mut("items")
                .unwrap()
                .as_array_mut()
                .unwrap()
                .remove(0);
            node.insert("items".into(), item);
            node.remove("additionalItems");
        }

        if let Some(reference) = node.remove("$ref").or_else(|| node.remove("#ref")) {
            let reference = reference
                .as_str()
                .ok_or_else(|| GenerationError("reference must be a string".into()))?;
            let name = self.reference(current, reference)?;
            node.insert(
                "$ref".into(),
                Value::String(format!("#/definitions/{}", escape_pointer(&name))),
            );
        }
        for key in ["properties", "patternProperties", "definitions"] {
            if let Some(children) = node.get_mut(key).and_then(Value::as_object_mut) {
                for child in children.values_mut() {
                    self.walk(child, current)?;
                }
            }
        }
        for key in [
            "items",
            "additionalProperties",
            "not",
            "allOf",
            "anyOf",
            "oneOf",
        ] {
            if let Some(child) = node.get_mut(key) {
                if let Some(children) = child.as_array_mut() {
                    for child in children {
                        self.walk(child, current)?;
                    }
                } else {
                    self.walk(child, current)?;
                }
            }
        }
        Ok(())
    }
}

fn apply_patch(doc: &mut Value, patch: &Value) -> Result<(), GenerationError> {
    for operation in patch
        .as_array()
        .ok_or_else(|| GenerationError("patch must be an array".into()))?
    {
        let path = operation["path"]
            .as_str()
            .ok_or_else(|| GenerationError("patch requires path".into()))?;
        match operation["op"].as_str() {
            Some("replace") => {
                let target = doc
                    .pointer_mut(path)
                    .ok_or_else(|| GenerationError(format!("patch path missing: {path}")))?;
                *target = operation
                    .get("value")
                    .cloned()
                    .ok_or_else(|| GenerationError("patch requires value".into()))?;
            }
            Some("add") => {
                let (parent, key) = path
                    .rsplit_once('/')
                    .ok_or_else(|| GenerationError("patch requires object member".into()))?;
                let parent = doc
                    .pointer_mut(parent)
                    .and_then(Value::as_object_mut)
                    .ok_or_else(|| GenerationError(format!("patch parent missing: {path}")))?;
                parent.insert(
                    unescape_pointer(key),
                    operation
                        .get("value")
                        .cloned()
                        .ok_or_else(|| GenerationError("patch requires value".into()))?,
                );
            }
            _ => {
                return Err(GenerationError(
                    "unsupported notification patch operation".into(),
                ));
            }
        }
    }
    Ok(())
}

/// Validate exact pinned source closure and tracked/clean patch inputs before export.
pub fn verify_sources(checkout: &Path, revision: &str) -> Result<(), GenerationError> {
    verify_pinned(
        checkout,
        revision,
        &[
            "schemas/reports",
            "schemas/feeds",
            "schemas/notifications",
            "schemas/data-kiosk",
        ],
        |path| {
            (path.ends_with(".json") || path.ends_with(".graphql")) && !path.contains(".example.")
        },
        &sources().into_iter().map(|source| source.path).collect(),
        "supplemental",
    )?;
    let root = checkout
        .parent()
        .ok_or_else(|| GenerationError("checkout requires parent".into()))?;
    for (name, bytes) in PATCHES {
        let source = format!("lib/generator/patches/{name}.json");
        if fs::read(root.join(&source))? != *bytes {
            return Err(GenerationError(format!(
                "notification patch modified: {source}"
            )));
        }
        // Synthetic source roots need not be a Peddler Git checkout. Actual roots do.
        if root.join(".git").exists() {
            git(root, &["ls-files", "--error-unmatch", "--", &source])?;
            if !git(root, &["status", "--porcelain", "--", &source])?.is_empty() {
                return Err(GenerationError(format!(
                    "notification patch modified: {source}"
                )));
            }
        }
    }
    Ok(())
}

const SHIPMENT_SOURCE: &str =
    "schemas/notifications/ShipmentTrackingMilestoneChangedNotification.json";
const TRACKING_SOURCE: &str = "models/tracking-api-model/tracking_2026-01-30.json";

/// Returns whether the schema needed the repair.
fn repair_shipment_schema(
    checkout: &Path,
    source: &str,
    doc: &mut Value,
) -> Result<bool, GenerationError> {
    if source != SHIPMENT_SOURCE
        || doc.get("$ref").and_then(Value::as_str) != Some("#/definitions/Notification")
        || doc.get("definitions") != Some(&json!({}))
    {
        return Ok(false);
    }
    let tracking: Value = serde_json::from_slice(&fs::read(checkout.join(TRACKING_SOURCE))?)?;
    let tracking_definitions = tracking["definitions"]
        .as_object()
        .ok_or_else(|| GenerationError("tracking definitions missing".into()))?;
    let mut definitions = serde_json::Map::new();
    let mut pending = vec!["TrackingDetail".to_owned()];
    while let Some(name) = pending.pop() {
        if definitions.contains_key(&name) {
            continue;
        }
        let mut schema = tracking_definitions
            .get(&name)
            .cloned()
            .ok_or_else(|| GenerationError(format!("missing canonical tracking type {name}")))?;
        tracking_references(&schema, &mut pending);
        retain_extensions(&mut schema);
        definitions.insert(name, schema);
    }
    definitions.insert(
        "NotificationMetadata".into(),
        json!({"type":"object", "additionalProperties":true,"properties":{
            "applicationId":{"type":"string"},"subscriptionId":{"type":"string"},
            "publishTime":{"type":"string","format":"date-time"},"notificationId":{"type":"string"}
        }}),
    );
    definitions.insert("Notification".into(), json!({"type":"object","additionalProperties":true,"description":"Repaired notification envelope; upstream has no definitions. Envelope fields are conservatively optional.","properties":{
        "notificationVersion":{"type":"string"},"notificationType":{"type":"string"},"payloadVersion":{"type":"string"},
        "eventTime":{"type":"string","format":"date-time"},"notificationMetadata":{"$ref":"#/definitions/NotificationMetadata"},
        "payload":{"type":"object","additionalProperties":true,"properties":{
            "shipmentTrackingMilestoneChangedNotification":{"type":"object","additionalProperties":true,"properties":{
                "trackingDetail":{"$ref":"#/definitions/TrackingDetail"}
            }}
        }}
    }}));
    doc["definitions"] = Value::Object(definitions);
    Ok(true)
}

fn tracking_references(schema: &Value, pending: &mut Vec<String>) {
    match schema {
        Value::Object(node) => {
            if let Some(name) = node
                .get("$ref")
                .and_then(Value::as_str)
                .and_then(|value| value.strip_prefix("#/definitions/"))
            {
                pending.push(name.into());
            }
            for child in node.values() {
                tracking_references(child, pending);
            }
        }
        Value::Array(children) => {
            for child in children {
                tracking_references(child, pending);
            }
        }
        _ => {}
    }
}

fn retain_extensions(schema: &mut Value) {
    if let Some(node) = schema.as_object_mut() {
        if node.get("type").and_then(Value::as_str) == Some("object") {
            node.insert("additionalProperties".into(), Value::Bool(true));
        }
        if let Some(children) = node.get_mut("properties").and_then(Value::as_object_mut) {
            for child in children.values_mut() {
                retain_extensions(child);
            }
        }
        if let Some(child) = node.get_mut("items") {
            retain_extensions(child);
        }
    }
}

// Typify 0.8 cannot generate an array with `contains`. Move this one audited
// localized-message constraint into generated Serde validation, retaining items.
fn take_eligibility_contains(source: &str, doc: &mut Value) -> Result<bool, GenerationError> {
    if source != "schemas/notifications/TaxInvoiceIssuanceEligibilityStatusChangeNotification.json"
    {
        return Ok(false);
    }
    let Some(message) = doc
        .pointer_mut("/definitions/Payload/properties/message")
        .and_then(Value::as_object_mut)
    else {
        return Ok(false);
    };
    let Some(contains) = message.remove("contains") else {
        return Ok(false);
    };
    if contains
        != json!({"type":"object","properties":{"locale":{"const":"en-US"}},"required":["locale"]})
    {
        return Err(GenerationError(
            "unexpected localized message contains constraint".into(),
        ));
    }
    Ok(true)
}

fn render(definitions: Definitions) -> Result<String, GenerationError> {
    let source = models::render(definitions.schemas)?;
    if !definitions.contains_en_us && definitions.feed_guards.is_empty() {
        return Ok(source);
    }
    let mut file = syn::parse_file(&source).map_err(|error| GenerationError(error.to_string()))?;
    for (name, forbidden) in &definitions.feed_guards {
        add_feed_validation(&mut file, name, forbidden)?;
    }
    if definitions.contains_en_us {
        add_en_us_validation(&mut file)?;
    }
    Ok(prettyplease::unparse(&file))
}

fn add_en_us_validation(file: &mut syn::File) -> Result<(), GenerationError> {
    let payload = file
        .items
        .iter_mut()
        .find_map(|item| match item {
            syn::Item::Struct(item) if item.ident == "Payload" => Some(item),
            _ => None,
        })
        .ok_or_else(|| GenerationError("missing typed eligibility payload".into()))?;
    let field = payload
        .fields
        .iter_mut()
        .find(|field| field.ident.as_ref().is_some_and(|name| name == "message"))
        .ok_or_else(|| GenerationError("missing localized messages field".into()))?;
    field.attrs.push(
        syn::parse_quote!(#[serde(default, deserialize_with = "deserialize_localized_messages")]),
    );
    let ty = field.ty.clone();
    let validator: syn::Item = syn::parse_quote! {
        fn deserialize_localized_messages<'de, D: serde::Deserializer<'de>>(deserializer: D) -> Result<#ty, D::Error> {
            let messages = <#ty as serde::Deserialize>::deserialize(deserializer)?;
            if let Some(messages) = &messages
                && !messages.iter().any(|message| message.locale == "en-US") {
                return Err(serde::de::Error::custom("localized messages must contain an en-US entry"));
            }
            Ok(messages)
        }
    };
    file.items.push(validator);
    Ok(())
}

/// Turns a schema whose `oneOf` refines it by `operationType` into one schema per
/// operation. Returns the fields each operation forbids, if it did.
fn expand_feed_branches(
    node: &mut serde_json::Map<String, Value>,
) -> Result<Option<Value>, GenerationError> {
    let Some(branches) = node.get("oneOf").and_then(Value::as_array) else {
        return Ok(None);
    };
    if !branches.iter().all(|branch| {
        branch
            .pointer("/properties/operationType/const")
            .and_then(Value::as_str)
            .is_some()
    }) {
        return Ok(None);
    }
    let Some(properties) = node.get("properties").and_then(Value::as_object) else {
        return Ok(None);
    };
    if node.get("type").and_then(Value::as_str) != Some("object") {
        return Ok(None);
    }
    let base_properties = properties.clone();
    let base_required = node
        .get("required")
        .and_then(Value::as_array)
        .cloned()
        .unwrap_or_default();
    let branches = branches.clone();
    let mut base = node.clone();
    base.remove("oneOf");
    base.remove("title");
    let mut expanded = Vec::new();
    let mut constraints = serde_json::Map::new();
    for branch in branches {
        let operation = branch
            .pointer("/properties/operationType/const")
            .and_then(Value::as_str)
            .unwrap();
        let forbidden: Vec<_> = branch["properties"]
            .as_object()
            .unwrap()
            .iter()
            .filter(|(_, value)| **value == Value::Bool(false))
            .map(|(name, _)| name.clone())
            .collect();
        constraints.insert(operation.into(), json!(forbidden));
        let mut combined = base.clone();
        let mut properties = base_properties.clone();
        for (name, refinement) in branch["properties"]
            .as_object()
            .ok_or_else(|| GenerationError("feed branch properties missing".into()))?
        {
            let schema = properties
                .get_mut(name)
                .ok_or_else(|| GenerationError(format!("unknown feed branch field {name}")))?;
            if *refinement == Value::Bool(false) {
                *schema = Value::Bool(false);
            } else {
                let original = schema.as_object_mut().ok_or_else(|| {
                    GenerationError("feed property schema must be an object".into())
                })?;
                for (key, value) in refinement
                    .as_object()
                    .ok_or_else(|| GenerationError("feed refinement must be object/false".into()))?
                {
                    original.insert(key.clone(), value.clone());
                }
            }
        }
        let mut required = base_required.clone();
        for name in branch
            .get("required")
            .and_then(Value::as_array)
            .into_iter()
            .flatten()
        {
            if !required.contains(name) {
                required.push(name.clone());
            }
        }
        combined.insert("properties".into(), Value::Object(properties));
        combined.insert("required".into(), Value::Array(required));
        if let Some(comment) = branch.get("$comment") {
            combined.insert("$comment".into(), comment.clone());
        }
        expanded.push(Value::Object(combined));
    }
    node.remove("properties");
    node.remove("required");
    node.remove("type");
    node.insert("oneOf".into(), Value::Array(expanded));
    Ok(Some(Value::Object(constraints)))
}

fn add_feed_validation(
    file: &mut syn::File,
    name: &str,
    constraints: &Value,
) -> Result<(), GenerationError> {
    let item = file
        .items
        .iter_mut()
        .find_map(|item| match item {
            syn::Item::Enum(item) if item.ident == name => Some(item),
            _ => None,
        })
        .ok_or_else(|| GenerationError(format!("missing feed enum {name}")))?;
    let original = item.ident.clone();
    let mut decode = item.clone();
    let helper = quote::format_ident!("{name}Decode");
    decode.ident = helper.clone();
    decode.vis = syn::Visibility::Inherited;
    for attr in &mut item.attrs {
        if attr.path().is_ident("derive") {
            let paths = attr
                .parse_args_with(
                    syn::punctuated::Punctuated::<syn::Path, syn::Token![,]>::parse_terminated,
                )
                .map_err(|error| GenerationError(error.to_string()))?;
            let kept = paths.iter().filter(|path| {
                !path
                    .segments
                    .last()
                    .is_some_and(|segment| segment.ident == "Deserialize")
            });
            *attr = syn::parse_quote!(#[derive(#(#kept),*)]);
        }
    }
    let mut conversions = Vec::new();
    for variant in &item.variants {
        let variant_name = &variant.ident;
        let syn::Fields::Named(fields) = &variant.fields else {
            return Err(GenerationError("unexpected feed variant fields".into()));
        };
        let fields = fields
            .named
            .iter()
            .map(|field| field.ident.as_ref().unwrap())
            .collect::<Vec<_>>();
        conversions.push(quote::quote! { #helper::#variant_name { #(#fields),* } => #original::#variant_name { #(#fields),* } });
    }
    let mut guard_arms = Vec::new();
    for (operation, fields) in constraints
        .as_object()
        .ok_or_else(|| GenerationError("missing feed constraints".into()))?
    {
        let names = fields
            .as_array()
            .unwrap()
            .iter()
            .map(|name| name.as_str().unwrap())
            .collect::<Vec<_>>();
        guard_arms.push(quote::quote! { Some(#operation) => &[#(#names),*], });
    }
    let implementation: syn::Item = syn::parse_quote! {
        impl<'de> serde::Deserialize<'de> for #original {
            fn deserialize<D: serde::Deserializer<'de>>(deserializer: D) -> Result<Self, D::Error> {
                let value = <serde_json::Value as serde::Deserialize>::deserialize(deserializer)?;
                let forbidden: &[&str] = match value.get("operationType").and_then(serde_json::Value::as_str) {
                    #(#guard_arms)*
                    _ => &[],
                };
                if forbidden.iter().any(|name| value.get(*name).is_some()) {
                    return Err(serde::de::Error::custom("field is forbidden for this feed operation"));
                }
                let decoded = serde_json::from_value::<#helper>(value).map_err(serde::de::Error::custom)?;
                Ok(match decoded { #(#conversions),* })
            }
        }
    };
    file.items.push(syn::Item::Enum(decode));
    file.items.push(implementation);
    Ok(())
}

// Some Amazon notifications reuse generic titles such as "The first anyOf
// schema" for unrelated objects. Typify treats those names as one type. Remove
// only conflicting titles so its contextual names preserve every distinct shape.
fn disambiguate_titles(definitions: &mut Value) {
    let mut shapes: BTreeMap<String, BTreeSet<String>> = BTreeMap::new();
    for schema in definitions.as_object_mut().unwrap().values_mut() {
        visit_schema(schema, &mut |node| {
            if let Some(title) = node.get("title").and_then(Value::as_str) {
                let mut shape = Value::Object(node.clone());
                visit_schema(&mut shape, &mut |node| {
                    for key in ["title", "description", "example", "examples"] {
                        node.remove(key);
                    }
                });
                shapes
                    .entry(title.into())
                    .or_default()
                    .insert(shape.to_string());
            }
        });
    }
    for schema in definitions.as_object_mut().unwrap().values_mut() {
        visit_schema(schema, &mut |node| {
            if node
                .get("title")
                .and_then(Value::as_str)
                .is_some_and(|title| shapes[title].len() > 1)
            {
                node.remove("title");
            }
        });
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn generated_arrays_maps_local_refs_and_sdl_decode_in_a_ruby_free_consumer() {
        let temp = tempfile::tempdir().unwrap();
        let schemas = temp.path().join("schemas");
        fs::create_dir_all(&schemas).unwrap();
        fs::write(schemas.join("array.json"), r#"{"type":"array","items":{"type":"object","required":["amount"],"properties":{"amount":{"type":"number"},"labels":{"type":"array","items":{"type":"string"}}}}}"#).unwrap();
        fs::write(schemas.join("map.json"), r##"{"type":"object","additionalProperties":{"$ref":"entry.json#/definitions/Entry"}}"##).unwrap();
        fs::write(schemas.join("entry.json"), r#"{"definitions":{"Entry":{"type":"object","required":["quantity"],"properties":{"quantity":{"type":"integer","format":"int64"}}}}}"#).unwrap();
        fs::write(schemas.join("selection.graphql"), "type Query { record: Record } type Record { labels: [String!]! nullableLabels: [String] nested: [[Int!]] amount: Float state: State } enum State { KNOWN }").unwrap();
        let src = temp.path().join("src");
        fs::create_dir(&src).unwrap();
        fs::write(
            src.join("array.rs"),
            render(json_definitions(temp.path(), "schemas/array.json", "Report", None).unwrap())
                .unwrap(),
        )
        .unwrap();
        fs::write(
            src.join("map.rs"),
            render(json_definitions(temp.path(), "schemas/map.json", "Feed", None).unwrap())
                .unwrap(),
        )
        .unwrap();
        fs::write(
            src.join("selection.rs"),
            render(graphql_definitions(&schemas.join("selection.graphql")).unwrap()).unwrap(),
        )
        .unwrap();
        fs::write(
            temp.path().join("Cargo.toml"),
            r#"[package]
name = "peddler-supplemental-fixture"
version = "0.0.0"
edition = "2024"
[workspace]
[dependencies]
serde = { version = "1", features = ["derive"] }
serde_json = { version = "1", features = ["arbitrary_precision"] }
chrono = { version = "0.4", features = ["serde"] }
regress = "0.12"
"#,
        )
        .unwrap();
        fs::copy(
            Path::new(env!("CARGO_MANIFEST_DIR")).join("../../Cargo.lock"),
            temp.path().join("Cargo.lock"),
        )
        .unwrap();
        fs::write(
            src.join("lib.rs"),
            include_str!("../tests/fixtures/supplemental_consumer.rs"),
        )
        .unwrap();
        // This consumer runs only committed Rust/Serde code, with no Ruby, Node,
        // SDL or schema access during its build. An isolated target avoids Cargo
        // locking the generator's target while its test process is running.
        let output = Command::new("cargo")
            .args(["test", "--offline", "--quiet", "--manifest-path"])
            .arg(temp.path().join("Cargo.toml"))
            .arg("--target-dir")
            .arg(Path::new(env!("CARGO_MANIFEST_DIR")).join("../../target/supplemental-fixtures"))
            .output()
            .unwrap();
        assert!(
            output.status.success(),
            "{}\n{}",
            String::from_utf8_lossy(&output.stdout),
            String::from_utf8_lossy(&output.stderr)
        );
    }
}
