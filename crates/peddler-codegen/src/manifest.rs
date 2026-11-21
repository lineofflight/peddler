//! The API models the generator reads, and their names. It reads every model in the
//! checkout and names it by the rules of the Ruby generator, so that a model Amazon adds
//! gets the same name from both, with no edit: `APINameResolver` names the family,
//! `API#version` the version, and Peddler 5's `VersionSelector` picked the latest.
use crate::{GenerationError, facades::RUBY_KEYWORDS};
use serde_json::Value;
use std::{
    collections::{BTreeMap, BTreeSet},
    path::Path,
};

/// An API model and its names.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct ModelSpec {
    /// The model's path under `models/`
    pub source: String,
    /// `<family>_<version>`, such as `orders_v0`: the Rust module and the method of
    /// `Client` in Ruby
    pub module: String,
    /// Such as `orders`. `client.orders` in Ruby is the latest version
    pub family: String,
    /// The model's `info.version`, such as `v0` or `2026_01_01`
    pub version: String,
    /// Whether it is the latest version of its family
    pub latest: bool,
}

/// The directories that hold several APIs, each named after its file. Any other API is
/// named after its directory. `APINameResolver::FILENAME_BASED_DIRECTORIES` in Ruby is the
/// same list, and a Ruby test holds the two together.
pub const FILENAME_BASED_DIRECTORIES: [&str; 2] = ["external-fulfillment", "finances-api-model"];

/// Whether a path under `models/` is an API model. Ruby's `Dir.glob("models/**/*.json")`
/// finds them: a JSON file at any depth, none hidden.
pub(crate) fn is_model(path: &str) -> bool {
    path.ends_with(".json") && !path.split('/').any(|part| part.starts_with('.'))
}

/// The path under `models` of every API model, in byte order.
pub fn sources(models: &Path) -> Result<Vec<String>, GenerationError> {
    crate::files(models, is_model)
}

/// Names each model by its path and its `info.version`, and marks the latest version of
/// each family. What it can't name, it refuses by the file: a directory that holds APIs of
/// different names and isn't one of `FILENAME_BASED_DIRECTORIES`, a version or a name that
/// can't be a method, and two models of one name.
pub fn derive(models: &[(String, Value)]) -> Result<Vec<ModelSpec>, GenerationError> {
    let mut by_directory: BTreeMap<&str, BTreeSet<&str>> = BTreeMap::new();
    for (source, _) in models {
        by_directory
            .entry(directory(source))
            .or_default()
            .insert(base_name(source));
    }
    for (directory, names) in by_directory {
        if names.len() > 1 && !FILENAME_BASED_DIRECTORIES.contains(&directory) {
            let files: Vec<_> = models
                .iter()
                .map(|(source, _)| source.as_str())
                .filter(|source| self::directory(source) == directory)
                .collect();
            return Err(GenerationError(format!(
                "{}: APIs of different names share the directory {directory}; add it to FILENAME_BASED_DIRECTORIES, in Rust and in Ruby",
                files.join(", ")
            )));
        }
    }
    let mut apis = Vec::new();
    let mut seen: BTreeMap<String, &str> = BTreeMap::new();
    for (source, spec) in models {
        let located = |message: String| GenerationError(format!("{source}: {message}"));
        let family = family(source);
        let version = version(spec).map_err(|error| located(error.0))?;
        let module = format!("{family}_{version}");
        if !identifier(&family) || !identifier(&module) || RUBY_KEYWORDS.contains(&family.as_str())
        {
            return Err(located(format!("{module} can't name an API")));
        }
        if let Some(other) = seen.insert(module.clone(), source) {
            return Err(located(format!("{other} is named {module} too")));
        }
        apis.push(ModelSpec {
            source: source.clone(),
            module,
            family,
            version,
            latest: false,
        });
    }
    let mut families: BTreeMap<String, Vec<String>> = BTreeMap::new();
    for api in &apis {
        families
            .entry(api.family.clone())
            .or_default()
            .push(api.version.clone());
    }
    for api in &mut apis {
        api.latest = latest(&families[&api.family]) == Some(api.version.as_str());
    }
    Ok(apis)
}

/// The name of an API's family, as `APINameResolver#name` gives it: its directory's,
/// without `-api-model` or `-model`, or in one of `FILENAME_BASED_DIRECTORIES` its file's,
/// without its version, in snake case.
pub fn family(source: &str) -> String {
    let directory = directory(source);
    if FILENAME_BASED_DIRECTORIES.contains(&directory) {
        let mut name = String::new();
        let mut previous = None;
        for c in base_name(source).chars() {
            if c.is_ascii_uppercase()
                && previous.is_some_and(|p: char| p.is_ascii_lowercase() || p.is_ascii_digit())
            {
                name.push('_');
            }
            name.push(c);
            previous = Some(c);
        }
        name.to_lowercase().replace('-', "_")
    } else {
        let name = directory.strip_suffix("-api-model").unwrap_or(directory);
        let name = name.strip_suffix("-model").unwrap_or(name);
        name.replace('-', "_")
    }
}

/// The version of an API, as `API#version` reads it from the spec: `info.version`, with
/// dashes as underscores. It names a module, so it must be a word.
pub fn version(spec: &Value) -> Result<String, GenerationError> {
    let version = spec["info"]["version"]
        .as_str()
        .ok_or_else(|| GenerationError("no info.version".into()))?
        .replace('-', "_");
    if version.is_empty()
        || !version
            .bytes()
            .all(|byte| byte.is_ascii_alphanumeric() || byte == b'_')
    {
        return Err(GenerationError(format!(
            "{version:?} is no version of an API"
        )));
    }
    Ok(version)
}

/// The latest of a family's versions, as Peddler 5's `VersionSelector` picked it: a dated
/// version is later than any `v` one, and within each kind the greater string is later.
pub fn latest(versions: &[String]) -> Option<&str> {
    let key = |version: &String| (!version.starts_with('v'), version.clone());
    versions
        .iter()
        .max_by(|a, b| key(a).cmp(&key(b)))
        .map(String::as_str)
}

/// The name of the directory a model is in. One directly under `models/` is in `models`.
fn directory(source: &str) -> &str {
    match source.rsplit_once('/') {
        Some((parent, _)) => parent.rsplit('/').next().unwrap_or(parent),
        None => "models",
    }
}

/// A model's file name without `.json`, a date at its end, or a `V` and a number at its
/// end, as `APINameResolver.extract_base_name` has it: `financesV0` is `finances`.
fn base_name(source: &str) -> &str {
    let file = source.rsplit('/').next().unwrap_or(source);
    let name = file.strip_suffix(".json").unwrap_or(file);
    let bytes = name.as_bytes();
    // `[_-]\d{4}[-_]\d{2}[-_]\d{2}$`
    let dated = bytes.len() >= 11 && {
        let date = &bytes[bytes.len() - 11..];
        date.iter().enumerate().all(|(i, byte)| match i {
            0 | 5 | 8 => matches!(byte, b'_' | b'-'),
            _ => byte.is_ascii_digit(),
        })
    };
    let name = if dated {
        &name[..name.len() - 11]
    } else {
        name
    };
    // `V\d+$`
    let digits = name.len() - name.trim_end_matches(|c: char| c.is_ascii_digit()).len();
    match name[..name.len() - digits].strip_suffix('V') {
        Some(stem) if digits > 0 => stem,
        _ => name,
    }
}

/// The words Peddler writes in capitals, as `lib/peddler/acronyms.rb` has them for the
/// models. A test in Ruby holds this list to that file, entry for entry.
pub const ACRONYMS: [(&str, &str); 16] = [
    ("Api", "API"),
    ("Apis", "APIs"),
    ("Asin", "ASIN"),
    ("B2b", "B2B"),
    ("Cgst", "CGST"),
    ("Cod", "COD"),
    ("Ebt", "EBT"),
    ("Fba", "FBA"),
    ("Igst", "IGST"),
    ("Lwa", "LWA"),
    ("Safet", "SAFET"),
    ("Sgst", "SGST"),
    ("Sku", "SKU"),
    ("Tds", "TDS"),
    ("Url", "URL"),
    ("Urls", "URLs"),
];
/// The name of an API's class in Ruby, which is that of its models' namespace: `FBAInventoryV1`.
/// A word is an acronym before a capital or at the end, so that `Cod` leaves `Code` alone.
pub fn ruby_class(module: &str) -> String {
    ACRONYMS
        .iter()
        .fold(crate::clients::pascal(module), |name, (from, to)| {
            let word = regress::Regex::new(&format!("{from}(?=[A-Z]|$)")).expect("valid pattern");
            word.replace_all(&name, to)
        })
}
/// Whether a name can be a Rust module and a Ruby method alike.
pub(crate) fn identifier(name: &str) -> bool {
    name.starts_with(|c: char| c.is_ascii_lowercase())
        && name
            .bytes()
            .all(|byte| byte.is_ascii_lowercase() || byte.is_ascii_digit() || byte == b'_')
        && syn::parse_str::<syn::Ident>(name).is_ok()
}

/// An API for the tests: Action Items 2026-06-01, the latest of its family
#[cfg(test)]
pub(crate) fn example() -> ModelSpec {
    let spec = serde_json::json!({"info": {"version": "2026-06-01"}});
    let source = "action-items-api-model/actionItems_2026-06-01.json".to_owned();
    derive(&[(source, spec)]).expect("a name").remove(0)
}
