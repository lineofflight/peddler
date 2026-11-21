//! Amazon's enum lists are documentation, not a contract: they change without a version
//! bump, one spec can spell a value two ways, and the API can return values the spec does
//! not list. Fields and arguments stay strings; the docs list the values as known values.
//! `lib/generator/support/known_values.rb` holds the same rule.
use serde_json::{Map, Value};

/// The enum values a schema declares inline, through a `$ref`, or on its array items.
pub(crate) fn enum_values<'a>(
    schema: &'a Value,
    definitions: Option<&'a Map<String, Value>>,
) -> &'a [Value] {
    let schema = deref(schema, definitions);
    if let Some(values) = schema["enum"].as_array() {
        return values;
    }
    let items = match &schema["items"] {
        Value::Array(items) => items.first().unwrap_or(&Value::Null),
        items => items,
    };
    let values = deref(items, definitions)["enum"].as_array();
    values.map_or(&[], Vec::as_slice)
}

/// The sentence that lists the known values, unless there are none or the description
/// lists them all already.
pub(crate) fn sentence(description: &str, values: &[Value]) -> Option<String> {
    if values.is_empty()
        || values
            .iter()
            .all(|value| description.contains(&text(value)))
    {
        return None;
    }
    let values: Vec<String> = values.iter().map(code).collect();
    Some(format!("Known values: {}.", values.join(", ")))
}

/// A description with the sentence that lists the known values after it.
pub(crate) fn append(description: &str, values: &[Value]) -> String {
    let Some(sentence) = sentence(description, values) else {
        return description.to_owned();
    };
    let description = description.trim_end();
    if description.is_empty() {
        return sentence;
    }
    let stop = if description.ends_with(['.', '!', '?']) {
        ""
    } else {
        "."
    };
    format!("{description}{stop} {sentence}")
}

fn text(value: &Value) -> String {
    match value {
        Value::String(text) => text.clone(),
        value => value.to_string(),
    }
}

/// A value as Markdown code. A spec is data: a value that holds a backtick is fenced by
/// a longer run of them, and its whitespace is a space, so the value reads as the text
/// it is.
fn code(value: &Value) -> String {
    let text = text(value).split_whitespace().collect::<Vec<_>>().join(" ");
    let run = text.split(|c| c != '`').map(str::len).max().unwrap_or(0);
    let fence = "`".repeat(run + 1);
    let pad = if text.starts_with('`') || text.ends_with('`') {
        " "
    } else {
        ""
    };
    format!("{fence}{pad}{text}{pad}{fence}")
}

fn deref<'a>(schema: &'a Value, definitions: Option<&'a Map<String, Value>>) -> &'a Value {
    let name = schema["$ref"].as_str().and_then(|r| r.rsplit('/').next());
    match (name, definitions) {
        (Some(name), Some(definitions)) => definitions.get(name).unwrap_or(schema),
        _ => schema,
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn values_come_inline_through_a_ref_or_on_array_items() {
        let definitions = json!({
            "Status": {"type": "string", "enum": ["Open", "Closed"]},
        });
        let definitions = definitions.as_object();
        let inline = json!({"type": "string", "enum": ["MFN", "AFN"]});
        let reference = json!({"$ref": "#/definitions/Status"});
        let items = json!({"type": "array", "items": {"type": "string", "enum": ["A"]}});
        let referenced_items = json!({"type": "array", "items": {"$ref": "#/definitions/Status"}});
        assert_eq!(enum_values(&inline, None), [json!("MFN"), json!("AFN")]);
        assert_eq!(
            enum_values(&reference, definitions),
            [json!("Open"), json!("Closed")]
        );
        assert_eq!(enum_values(&items, None), [json!("A")]);
        assert_eq!(
            enum_values(&referenced_items, definitions),
            [json!("Open"), json!("Closed")]
        );
        assert!(enum_values(&reference, None).is_empty());
        assert!(enum_values(&json!({"type": "string"}), definitions).is_empty());
    }

    #[test]
    fn the_sentence_follows_the_description() {
        let values = [json!("MFN"), json!("AFN")];
        assert_eq!(
            append("The channel", &values),
            "The channel. Known values: `MFN`, `AFN`."
        );
        assert_eq!(
            append("The channel? ", &values),
            "The channel? Known values: `MFN`, `AFN`."
        );
        assert_eq!(append("", &values), "Known values: `MFN`, `AFN`.");
        assert_eq!(append("The channel.", &[]), "The channel.");
    }

    #[test]
    fn a_description_that_lists_every_value_keeps_its_own_list() {
        let values = [json!("Open"), json!("Closed")];
        let listed = "Possible values: `Open`, `Closed`.";
        assert_eq!(append(listed, &values), listed);
        assert_eq!(sentence(listed, &values), None);
        assert_eq!(
            append("Possible values: `Open`.", &values),
            "Possible values: `Open`. Known values: `Open`, `Closed`."
        );
    }

    #[test]
    fn a_hostile_value_is_written_as_text() {
        let values = [
            json!("a`b"),
            json!("`c`"),
            json!("#{exit}"),
            json!("\"d\""),
            json!("e\n\n:stopdoc:\n@rbs f"),
            json!(1),
        ];
        assert_eq!(
            append("", &values),
            "Known values: ``a`b``, `` `c` ``, `#{exit}`, `\"d\"`, `e :stopdoc: @rbs f`, `1`."
        );
    }
}
