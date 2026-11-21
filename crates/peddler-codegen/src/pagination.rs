//! Explicit pagination metadata, checked against the pinned specs.
//!
//! `pagination.json` is the only source of mappings. Every mapped operation,
//! argument and response path is resolved against the spec, and every operation
//! with continuation-like fields must be mapped or excluded with a reason.
use crate::{
    GenerationError,
    clients::{Operation, Parameter},
    escape_pointer,
    manifest::ModelSpec,
};
use serde::Deserialize;
use serde_json::Value;
use std::{
    collections::{BTreeMap, BTreeSet},
    fs,
    path::Path,
};

pub const SOURCE: &str = "crates/peddler-codegen/pagination.json";

#[derive(Debug, Default, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Source {
    pub mappings: Vec<Mapping>,
    pub exclusions: Vec<Exclusion>,
}
#[derive(Clone, Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Mapping {
    pub operation: String,
    pub input: String,
    pub output: String,
    #[serde(default)]
    pub continuation: Continuation,
}
#[derive(Clone, Debug, Default, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Continuation {
    pub operation: Option<String>,
    pub keep: Option<Vec<String>>,
    #[serde(default)]
    pub drop: Vec<String>,
    #[serde(default)]
    pub set: BTreeMap<String, Value>,
    /// Generate a private continuation operation that sends only the token and
    /// the kept path parameters, bypassing the initial request's requiredness.
    #[serde(default)]
    pub adapter: bool,
}
#[derive(Debug, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Exclusion {
    pub operation: String,
    pub reason: String,
}

#[derive(Clone, Debug)]
pub struct Resolved {
    pub module: String,
    pub name: String,
    pub key: String,
    pub mapping: Mapping,
    /// Operation key used for pages after the first, when different.
    pub continuation_operation: Option<String>,
}
impl Resolved {
    pub fn adapter_key(&self) -> Option<String> {
        self.mapping
            .continuation
            .adapter
            .then(|| format!("{}.continue", self.key))
    }
}

/// Reads the mapping file under `root`. A missing file means no mappings,
/// which is how synthetic test repositories generate without pagination.
pub fn load(root: &Path) -> Result<Source, GenerationError> {
    match fs::read(root.join(SOURCE)) {
        Ok(bytes) => Ok(serde_json::from_slice(&bytes)?),
        Err(error) if error.kind() == std::io::ErrorKind::NotFound => Ok(Source::default()),
        Err(error) => Err(error.into()),
    }
}

type Clients<'a> = [(&'a ModelSpec, Vec<Operation>)];

fn fail<T>(message: String) -> Result<T, GenerationError> {
    Err(GenerationError(format!("pagination: {message}")))
}

fn definition<'a>(spec: &'a Value, schema: &'a Value) -> &'a Value {
    let mut schema = schema;
    for _ in 0..32 {
        let Some(name) = schema
            .get("$ref")
            .and_then(Value::as_str)
            .and_then(|r| r.strip_prefix("#/definitions/"))
        else {
            break;
        };
        match spec.pointer(&format!("/definitions/{name}")) {
            Some(next) => schema = next,
            None => break,
        }
    }
    schema
}
fn property<'a>(spec: &'a Value, schema: &'a Value, name: &str, depth: usize) -> Option<&'a Value> {
    if depth > 8 {
        return None;
    }
    let schema = definition(spec, schema);
    schema
        .pointer(&format!("/properties/{}", escape_pointer(name)))
        .or_else(|| {
            schema
                .get("allOf")?
                .as_array()?
                .iter()
                .find_map(|part| property(spec, part, name, depth + 1))
        })
}
fn walk<'a>(spec: &'a Value, schema: &'a Value, path: &[&str]) -> Option<&'a Value> {
    let mut node = schema;
    for key in path {
        node = property(spec, node, key, 0)?;
    }
    Some(definition(spec, node))
}
fn raw_operation<'a>(spec: &'a Value, op: &Operation) -> Result<&'a Value, GenerationError> {
    spec.pointer(&format!(
        "/paths/{}/{}",
        escape_pointer(&op.path),
        op.method.to_ascii_lowercase()
    ))
    .ok_or_else(|| GenerationError(format!("pagination: {} missing in spec", op.id)))
}
fn success_schema(raw: &Value) -> Option<&Value> {
    let responses = raw.get("responses")?.as_object()?;
    let response = responses.get("200").or_else(|| {
        responses
            .iter()
            .find(|(s, _)| s.starts_with('2'))
            .map(|(_, r)| r)
    })?;
    response.get("schema")
}

fn pointer_segments(pointer: &str, what: &str) -> Result<Vec<String>, GenerationError> {
    let Some(rest) = pointer.strip_prefix('/') else {
        return fail(format!("{what} pointer {pointer} must start with /"));
    };
    let segments: Vec<String> = rest.split('/').map(str::to_owned).collect();
    if segments.iter().any(|s| s.is_empty() || s.contains('~')) {
        return fail(format!(
            "{what} pointer {pointer} has an empty or escaped segment"
        ));
    }
    Ok(segments)
}

fn parameter<'a>(op: &'a Operation, name: &str) -> Option<&'a Parameter> {
    op.parameters.iter().find(|p| p.name == name)
}

fn locate<'a>(
    clients: &'a Clients<'a>,
    key: &str,
) -> Result<(&'a ModelSpec, &'a Operation), GenerationError> {
    let found = key.split_once('.').and_then(|(module, name)| {
        let (api, operations) = clients.iter().find(|(api, _)| api.module == module)?;
        Some((*api, operations.iter().find(|op| op.name == name)?))
    });
    found.ok_or_else(|| GenerationError(format!("pagination: unknown operation {key}")))
}

/// Resolves every mapping against specs and operations and audits
/// that no continuation-like operation is left undecided.
pub fn resolve(
    source: &Source,
    clients: &Clients<'_>,
    specs: &BTreeMap<&str, Value>,
) -> Result<Vec<Resolved>, GenerationError> {
    let mut resolved = Vec::new();
    let mut decided = BTreeSet::new();
    for mapping in &source.mappings {
        if !decided.insert(mapping.operation.clone()) {
            return fail(format!("{} is decided twice", mapping.operation));
        }
        let (api, op) = locate(clients, &mapping.operation)?;
        let spec = &specs[api.module];
        let raw = raw_operation(spec, op)?;
        let input = pointer_segments(&mapping.input, "input")?;
        let output = pointer_segments(&mapping.output, "output")?;
        let token = parameter(op, &input[0]).ok_or_else(|| {
            GenerationError(format!(
                "pagination: {} has no argument {}",
                op.name, input[0]
            ))
        })?;
        if input.len() == 1 {
            if !["query", "header"].contains(&token.location.as_str())
                || token.schema["type"] != "string"
            {
                return fail(format!("{} input must be a string query argument", op.name));
            }
        } else {
            let body = raw["parameters"]
                .as_array()
                .into_iter()
                .flatten()
                .find(|p| p["in"] == "body")
                .and_then(|p| p.get("schema"));
            let path: Vec<&str> = input[1..].iter().map(String::as_str).collect();
            let leaf = token
                .location
                .eq("body")
                .then_some(body)
                .flatten()
                .and_then(|schema| walk(spec, schema, &path));
            if leaf.is_none_or(|leaf| leaf["type"] != "string") {
                return fail(format!(
                    "{} body input {} is not a string",
                    op.name, mapping.input
                ));
            }
        }
        let path: Vec<&str> = output.iter().map(String::as_str).collect();
        let leaf = success_schema(raw).and_then(|schema| walk(spec, schema, &path));
        if leaf.is_none_or(|leaf| leaf["type"] != "string") {
            return fail(format!(
                "{} output {} is not a string in the success response",
                op.name, mapping.output
            ));
        }
        let c = &mapping.continuation;
        let mut continuation_operation = c.operation.clone();
        let target = match &c.operation {
            Some(key) => {
                let (target_api, target) = locate(clients, key)?;
                if target_api.module != api.module {
                    return fail(format!(
                        "{key} must be in the same API as {}",
                        mapping.operation
                    ));
                }
                target
            }
            None => op,
        };
        for name in c.keep.iter().flatten().chain(&c.drop).chain(c.set.keys()) {
            if parameter(target, name).is_none() {
                return fail(format!("{} has no argument {name}", target.name));
            }
        }
        for (name, value) in &c.set {
            let schema = &parameter(target, name).expect("checked above").schema;
            let valid = match schema["type"].as_str() {
                Some("string") => value.as_str().is_some_and(|v| {
                    schema["enum"]
                        .as_array()
                        .is_none_or(|values| values.iter().any(|e| e == v))
                }),
                Some("boolean") => value.is_boolean(),
                Some("integer" | "number") => value.is_number(),
                _ => false,
            };
            if !valid {
                return fail(format!(
                    "{} value for {name} does not fit its schema",
                    op.name
                ));
            }
        }
        if c.adapter {
            let path_parameters: BTreeSet<_> = op
                .parameters
                .iter()
                .filter(|p| p.location == "path")
                .map(|p| p.name.as_str())
                .collect();
            let keep: BTreeSet<_> = c.keep.iter().flatten().map(String::as_str).collect();
            if c.operation.is_some()
                || !c.drop.is_empty()
                || !c.set.is_empty()
                || op.method != "GET"
                || op.body().is_some()
                || input.len() != 1
                || token.location != "query"
                || keep != path_parameters
            {
                return fail(format!(
                    "{} adapter must be a GET that keeps exactly its path arguments",
                    op.name
                ));
            }
            continuation_operation = Some(format!("{}.continue", mapping.operation));
        }
        // A continuation keeps every parameter the spec marks required.
        let adapter_keep: BTreeSet<&str> = c.keep.iter().flatten().map(String::as_str).collect();
        for p in target.parameters.iter().filter(|p| p.required) {
            let kept = p.name == input[0]
                || c.set.contains_key(&p.name)
                || match (&c.keep, c.adapter) {
                    (Some(_), _) | (_, true) => adapter_keep.contains(p.name.as_str()),
                    (None, false) => !c.drop.contains(&p.name),
                };
            if !kept {
                return fail(format!(
                    "{} continuation drops required parameter {}",
                    mapping.operation, p.name
                ));
            }
        }
        resolved.push(Resolved {
            module: api.module.to_owned(),
            name: op.name.clone(),
            key: mapping.operation.clone(),
            mapping: mapping.clone(),
            continuation_operation,
        });
    }
    for exclusion in &source.exclusions {
        locate(clients, &exclusion.operation)?;
        if exclusion.reason.trim().is_empty() || !decided.insert(exclusion.operation.clone()) {
            return fail(format!(
                "{} is decided twice or lacks a reason",
                exclusion.operation
            ));
        }
    }
    for (api, operations) in clients {
        let spec = &specs[api.module];
        for op in operations {
            let key = format!("{}.{}", api.module, op.name);
            if !decided.contains(&key)
                && let Some(hit) = undecided(spec, op)?
            {
                return fail(format!(
                    "{key} has continuation-like field {hit}; map or exclude it"
                ));
            }
        }
    }
    resolved.sort_by(|a, b| a.key.cmp(&b.key));
    Ok(resolved)
}

fn names(
    spec: &Value,
    schema: &Value,
    needles: &[&str],
    depth: usize,
    max: usize,
) -> Option<String> {
    if depth > max {
        return None;
    }
    let schema = definition(spec, schema);
    let mut children: Vec<(&str, &Value)> = schema
        .get("properties")
        .and_then(Value::as_object)
        .into_iter()
        .flatten()
        .map(|(k, v)| (k.as_str(), v))
        .collect();
    children.extend(
        schema
            .get("allOf")
            .and_then(Value::as_array)
            .into_iter()
            .flatten()
            .map(|part| ("", part)),
    );
    for (key, child) in children {
        if key.is_empty() {
            if let Some(hit) = names(spec, child, needles, depth, max) {
                return Some(hit);
            }
            continue;
        }
        let lower = key.to_ascii_lowercase();
        if needles.iter().any(|n| lower.contains(n)) {
            return Some(key.to_owned());
        }
        if let Some(hit) = names(spec, child, needles, depth + 1, max) {
            return Some(format!("{key}/{hit}"));
        }
    }
    if let Some(items) = schema.get("items") {
        return names(spec, items, needles, depth + 1, max);
    }
    None
}

fn undecided(spec: &Value, op: &Operation) -> Result<Option<String>, GenerationError> {
    let request = [
        "token",
        "offset",
        "startindex",
        "nextpage",
        "cursor",
        "continuation",
    ];
    let response = [
        "token",
        "nextpage",
        "pageindex",
        "cursor",
        "continuation",
        "nextindex",
    ];
    for p in &op.parameters {
        let lower = p.wire_name.to_ascii_lowercase();
        if p.location != "body" && request.iter().any(|n| lower.contains(n)) {
            return Ok(Some(p.wire_name.clone()));
        }
    }
    let raw = raw_operation(spec, op)?;
    for p in raw["parameters"].as_array().into_iter().flatten() {
        if p["in"] == "body"
            && let Some(hit) = names(spec, &p["schema"], &request, 0, 3)
        {
            return Ok(Some(format!("body/{hit}")));
        }
    }
    if let Some(schema) = success_schema(raw)
        && let Some(hit) = names(spec, schema, &response, 0, 8)
    {
        return Ok(Some(format!("response/{hit}")));
    }
    Ok(None)
}

fn string(value: &str) -> String {
    format!("{value:?}")
}
fn list(values: &[String]) -> String {
    format!(
        "vec![{}]",
        values
            .iter()
            .map(|v| format!("{}.to_owned()", string(v)))
            .collect::<Vec<_>>()
            .join(", ")
    )
}

/// A Rust expression building the `crate::pagination::Pagination` for `r`.
pub fn rust_expression(r: &Resolved) -> String {
    let c = &r.mapping.continuation;
    let keep = match &c.keep {
        Some(keep) => format!("Some({})", list(keep)),
        None => "None".into(),
    };
    let operation = match &r.continuation_operation {
        Some(key) => format!("Some({}.to_owned())", string(key)),
        None => "None".into(),
    };
    let set = c
        .set
        .iter()
        .map(|(k, v)| format!("({}.to_owned(), serde_json::json!({v}))", string(k)))
        .collect::<Vec<_>>()
        .join(", ");
    format!(
        "crate::pagination::Pagination {{ operation: {}.to_owned(), input: {}.to_owned(), output: {}.to_owned(), continuation: crate::pagination::Continuation {{ operation: {operation}, keep: {keep}, drop: {}, set: vec![{set}] }} }}",
        string(&r.key),
        string(&r.mapping.input),
        string(&r.mapping.output),
        list(&c.drop)
    )
}

/// Ruby source building the matching `Pagination`.
pub fn ruby_expression(r: &Resolved) -> String {
    let c = &r.mapping.continuation;
    let strings = |values: &[String]| {
        format!(
            "[{}]",
            values
                .iter()
                .map(|v| string(v))
                .collect::<Vec<_>>()
                .join(", ")
        )
    };
    let mut parts = Vec::new();
    if let Some(key) = &r.continuation_operation {
        parts.push(format!("operation: {}", string(key)));
    }
    if let Some(keep) = &c.keep {
        parts.push(format!("keep: {}", strings(keep)));
    }
    if !c.drop.is_empty() {
        parts.push(format!("drop: {}", strings(&c.drop)));
    }
    if !c.set.is_empty() {
        let set = c
            .set
            .iter()
            .map(|(k, v)| format!("{} => {v}", string(k)))
            .collect::<Vec<_>>()
            .join(", ");
        parts.push(format!("set: {{ {set} }}"));
    }
    let continuation = if parts.is_empty() {
        String::new()
    } else {
        format!(", continuation: Continuation.new({})", parts.join(", "))
    };
    format!(
        "Pagination.new(operation: {}, input: {}, output: {}{continuation})",
        string(&r.key),
        string(&r.mapping.input),
        string(&r.mapping.output)
    )
}
