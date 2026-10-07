//! The YARD comment of a generated Ruby method, from the spec fields v5 read and
//! wrapped as v5 wrapped it. `lib/generator` on `main` has the Ruby this follows.
use crate::{
    clients::{Operation, Parameter, snake},
    manifest::ModelSpec,
};
use regress::Regex;
use serde_json::Value;
use std::sync::LazyLock;

/// How wide a line of generated Ruby may be
const WIDTH: usize = 120;
/// How deep an API's class sits, and an accessor of `Client`
const CLASS: usize = 4;
/// How deep an operation's method sits
const METHOD: usize = 6;
/// What Ruby's `\s` matches, as a character class. A regex's own `\s` matches more.
const SPACE: &str = r" \t\r\n\f\v";

fn regex(pattern: &str) -> Regex {
    Regex::with_flags(&pattern.replace("\\s", SPACE), "u").expect("valid pattern")
}

/// The comment above an operation's method: its description, a note on the sandbox,
/// each argument and what it returns.
pub(crate) fn operation(op: &Operation) -> String {
    let mut lines = wrap(&description(&op.description), METHOD, 0);
    lines.push("#".into());
    if let Some(kind) = op.sandbox {
        lines.extend(tag(&format!(
            "@note This operation can make a {kind} sandbox call."
        )));
    }
    let mut parameters: Vec<&Parameter> = op.parameters.iter().collect();
    parameters.sort_by_key(|p| p.position);
    for p in parameters {
        static SPACES: LazyLock<Regex> = LazyLock::new(|| regex(r"[\s]+"));
        let description = p.description.as_deref().unwrap_or_default();
        let description = links(&SPACES.replace_all(description, " "));
        let name = snake(&p.wire_name);
        lines.extend(tag(&format!(
            "@param {name} [{}] {description}",
            accepts(p)
        )));
    }
    lines.extend(tag("@return [Peddler::Response] The API response"));
    indent(&lines, METHOD)
}

/// The comment above the method that enumerates an operation's pages.
pub(crate) fn pages(op: &Operation) -> String {
    let line = format!(
        "# @return [Enumerator<Peddler::Response>] each page of {{#{}}}",
        op.name
    );
    indent(&[line], METHOD)
}

/// The comment above an API's class, as v5 wrote it: the spec's title, its description
/// and a link to the spec.
pub(crate) fn class(api: &ModelSpec, info: &Value) -> String {
    let text = |key: &str| info[key].as_str().unwrap_or_default();
    let mut lines = wrap(text("title"), CLASS, 0);
    lines.push("#".into());
    lines.extend(wrap(&links(text("description")), CLASS, 0));
    lines.push("#".into());
    lines.push(format!(
        "# @see https://github.com/amzn/selling-partner-api-models/blob/main/models/{}",
        api.source
    ));
    indent(&lines, CLASS)
}

/// The comment above the method of `Client` that returns an API: the class, the
/// spec's title and its version.
pub(crate) fn accessor(class: &str, info: &Value) -> String {
    let words = |key: &str| {
        let text = info[key].as_str().unwrap_or_default();
        text.split_whitespace().collect::<Vec<_>>().join(" ")
    };
    let line = format!(
        "# @return [Peddler::Native::{class}] {}, version {}",
        words("title").trim_end_matches('.'),
        words("version")
    );
    indent(&[line], CLASS)
}

/// Comment lines as Ruby source. A spec is data: whatever it holds, a line break in it
/// must not end a comment and start code, so none gets through here.
fn indent(lines: &[String], depth: usize) -> String {
    let margin = " ".repeat(depth);
    let lines = lines
        .iter()
        .map(|line| format!("{margin}{}\n", line.replace(['\n', '\r'], " ")));
    lines.collect()
}

/// What `Peddler::Native::Arguments` takes for a parameter.
fn accepts(p: &Parameter) -> &'static str {
    if p.location == "body" {
        return "Hash, Array, String";
    }
    match p.schema["type"].as_str() {
        Some("array") => "Array<String>",
        Some("boolean") => "Boolean",
        Some("integer") => "Integer",
        Some("number") => "Integer, Float",
        _ => "String",
    }
}

/// An operation's description without its usage plan, which Peddler doesn't act on.
fn description(text: &str) -> String {
    // Some specs spell a line break as a backslash and an n.
    let delimiter = if text.contains("\\n") { "\\n" } else { "\n" };
    let lines: Vec<&str> = text.split(delimiter).collect();
    let end = lines
        .iter()
        .position(|line| line.to_lowercase().contains("usage plan"));
    let text = lines[..end.unwrap_or(lines.len())].join("\n");
    static SECTION: LazyLock<Regex> =
        LazyLock::new(|| regex(r"([^\s])[\s]*((\*\*|__)(Note|Examples?):(\*\*|__))"));
    links(&SECTION.replace_all(strip(&text), "$1\n\n$2"))
}

/// Amazon's links as YARD's, and its bold spelled one way.
fn links(text: &str) -> String {
    static QUOTED: LazyLock<Regex> =
        LazyLock::new(|| regex(r#"<a href=['"]([^'"]+)['"]>([^<]+)</a>"#));
    static BARE: LazyLock<Regex> = LazyLock::new(|| regex(r"<a href=([^\s>]+)>([^<]+)</a>"));
    static BOLD: LazyLock<Regex> = LazyLock::new(|| regex(r"__([^\n]*?)__"));
    static DOC: LazyLock<Regex> = LazyLock::new(|| regex(r"\[([^\[\]]+)\]\(doc:([^()\s]+)\)"));
    let text = QUOTED.replace_all(text, "{$1 $2}");
    let text = BARE.replace_all(&text, "{$1 $2}");
    let text = BOLD.replace_all(&text, "**$1**");
    DOC.replace_all(
        &text,
        "{https://developer-docs.amazon.com/sp-api/docs/$2 $1}",
    )
}

/// What Ruby's `strip` leaves.
fn strip(text: &str) -> &str {
    text.trim_matches(|c: char| c.is_ascii_whitespace() || matches!(c, '\x0B' | '\0'))
}

/// A tag's lines above a method. Those after the first are indented under it.
fn tag(text: &str) -> Vec<String> {
    wrap(text, METHOD, 2)
}

/// Text as comment lines no wider than a line of Ruby may be. A blank line stays a
/// break, a line that ends a sentence ends its paragraph, and a note starts its own.
fn wrap(text: &str, depth: usize, hanging: usize) -> Vec<String> {
    const SECTIONS: [&str; 5] = ["**Note", "**Warning", "**Important", "**Example", "**Usage"];
    let mut paragraphs: Vec<String> = Vec::new();
    let mut current: Vec<&str> = Vec::new();
    // Ruby's `split` drops the empty lines a text ends with.
    for line in text.trim_end_matches('\n').split('\n') {
        let line = strip(line);
        if line.is_empty() {
            if !current.is_empty() {
                paragraphs.push(std::mem::take(&mut current).join(" "));
            }
            paragraphs.push(String::new());
        } else if SECTIONS.iter().any(|section| line.starts_with(section)) {
            if !current.is_empty() {
                paragraphs.push(std::mem::take(&mut current).join(" "));
            }
            if paragraphs.last().is_some_and(|last| !last.is_empty()) {
                paragraphs.push(String::new());
            }
            current.push(line);
        } else {
            current.push(line);
            if line.ends_with(['.', '!', '?', ':']) {
                paragraphs.push(std::mem::take(&mut current).join(" "));
            }
        }
    }
    if !current.is_empty() {
        paragraphs.push(current.join(" "));
    }
    let width = WIDTH - depth - 2;
    let mut lines = Vec::new();
    for paragraph in &paragraphs {
        let mut words: Vec<&str> = Vec::new();
        let mut first = true;
        let mut flush = |words: &mut Vec<&str>, first: bool| {
            let margin = if first { 0 } else { hanging };
            let line = format!("# {}{}", " ".repeat(margin), words.join(" "));
            lines.push(line.trim_end().to_owned());
            words.clear();
        };
        // A paragraph that is a comment already loses its marker.
        let unmarked = strip(paragraph).strip_prefix('#').map(strip);
        for word in unmarked.unwrap_or(paragraph).split_ascii_whitespace() {
            let length = words
                .iter()
                .map(|word| word.chars().count() + 1)
                .sum::<usize>()
                + word.chars().count();
            let room = if first { width } else { width - hanging };
            if length > room {
                flush(&mut words, first);
                first = false;
            }
            words.push(word);
        }
        if !words.is_empty() || paragraph.is_empty() {
            flush(&mut words, first);
        }
    }
    if lines.is_empty() {
        lines.push("#".into());
    }
    lines
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    #[test]
    fn a_line_break_in_a_spec_never_ends_a_comment() {
        // Line breaks of every kind, the bytes Ruby ends a script at, and what starts a
        // block comment, the data section or a comment of its own.
        let hostile = concat!(
            "A title.\nexit 1\r\nexit 2\rexit 3\n\n**Note:** x\n# exit 4\n",
            "a\u{2028}exit 5\u{2029}exit 6\u{85}exit 7\u{b}exit 8\u{c}exit 9\n",
            "b\0exit 10\u{4}exit 11\u{1a}exit 12\n__END__\n=begin\nexit 13\n=end\n",
            "c\\nexit 14"
        );
        let info = json!({"title": hostile, "description": hostile, "version": hostile});
        let parameter = Parameter {
            name: "id".into(),
            wire_name: "id".into(),
            position: 0,
            location: "query".into(),
            description: Some(hostile.into()),
            required: true,
            schema: json!({"type": "string"}),
            csv: false,
        };
        let op = Operation {
            id: "getThing".into(),
            name: "get_thing\nexit 15".into(),
            method: "GET".into(),
            path: "/things".into(),
            description: hostile.into(),
            sandbox: Some("static"),
            parameters: vec![parameter],
            successes: Vec::new(),
        };
        let api = &crate::manifest::ALL_APIS[0];
        let comments = [
            class(api, &info),
            accessor("Thing", &info),
            operation(&op),
            pages(&op),
        ];
        for comment in comments {
            assert!(comment.ends_with('\n') && !comment.contains('\r'));
            for line in comment.lines() {
                assert!(
                    line.trim_start().starts_with('#'),
                    "{line:?} in {comment:?}"
                );
            }
        }
    }
}
