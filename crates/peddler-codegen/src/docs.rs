//! The comment of a generated Ruby method, from the spec fields v5 read and wrapped
//! as v5 wrapped it, with the method's types as inline RBS. The text is Markdown, which
//! RDoc reads. `lib/generator` on `main` has the Ruby the text follows.
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

/// What the keyword every method takes last accepts, in RBS.
pub(crate) const RATE_LIMIT: &str = "(Float | Integer)?";

/// The comment above an operation's method: its description, a note on the sandbox,
/// each argument and what it returns.
pub(crate) fn operation(op: &Operation) -> String {
    let mut lines = prose(&description(&op.description), METHOD);
    lines.push("#".into());
    if let Some(kind) = op.sandbox {
        lines.push(format!("# This operation can make a {kind} sandbox call."));
        lines.push("#".into());
    }
    let mut parameters: Vec<&Parameter> = op.parameters.iter().collect();
    parameters.sort_by_key(|p| p.position);
    for p in parameters {
        static SPACES: LazyLock<Regex> = LazyLock::new(|| regex(r"[\s]+"));
        let description = p.description.as_deref().unwrap_or_default();
        let description = links(&SPACES.replace_all(description, " "));
        let name = snake(&p.wire_name);
        let ty = rbs_type(p);
        lines.extend(annotation(&if description.is_empty() {
            format!("@rbs {name}: {ty}")
        } else {
            format!("@rbs {name}: {ty} -- {description}")
        }));
    }
    lines.push(format!(
        "# @rbs rate_limit: {RATE_LIMIT} -- Requests per second"
    ));
    lines.push("# @rbs return: Response".into());
    indent(&lines, METHOD)
}

/// The comment above the method that enumerates an operation's pages. It takes its
/// whole type in 1 line: a line for each argument would leave any it missed untyped.
pub(crate) fn pages(op: &Operation, types: &str) -> String {
    let text = format!(
        "Each page of #{}. `rate_limit` applies to every page.",
        op.name
    );
    let mut lines = prose(&text, METHOD);
    lines.push(format!("#: ({types}) -> Enumerator[Response, void]"));
    indent(&lines, METHOD)
}

/// The comment above an API's class, as v5 wrote it: the spec's title, its description
/// and a link to the spec.
pub(crate) fn class(api: &ModelSpec, info: &Value) -> String {
    let text = |key: &str| info[key].as_str().unwrap_or_default();
    let mut lines = prose(text("title"), CLASS);
    lines.push("#".into());
    lines.extend(prose(&links(text("description")), CLASS));
    lines.push("#".into());
    lines.push(format!(
        "# https://github.com/amzn/selling-partner-api-models/blob/main/models/{}",
        api.source
    ));
    indent(&lines, CLASS)
}

/// The comment above the method of `Client` that returns an API: the spec's title,
/// its version and the class.
pub(crate) fn accessor(class: &str, info: &Value) -> String {
    let words = |key: &str| {
        let text = info[key].as_str().unwrap_or_default();
        text.split_whitespace().collect::<Vec<_>>().join(" ")
    };
    let text = format!(
        "{}, version {}",
        words("title").trim_end_matches('.'),
        words("version")
    );
    let mut lines = prose(&text, CLASS);
    lines.push(format!("#: () -> Native::{class}"));
    indent(&lines, CLASS)
}

/// The comment above the method of `Client` that returns the latest version of an API.
pub(crate) fn latest(class: &str, module: &str) -> String {
    let lines = [
        format!("# The latest version: #{module}"),
        format!("#: () -> Native::{class}"),
    ];
    indent(&lines, CLASS)
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

/// What a method takes for a parameter, in RBS. An optional one may be nil.
pub(crate) fn rbs_type(p: &Parameter) -> String {
    let ty = if p.location == "body" {
        "untyped"
    } else {
        match p.schema["type"].as_str() {
            Some("array") => "Array[String]",
            Some("boolean") => "bool",
            Some("integer") => "Integer",
            Some("number") => "Float | Integer",
            _ => "String",
        }
    };
    match ty {
        _ if p.required => ty.into(),
        _ if ty.contains('|') => format!("({ty})?"),
        _ => format!("{ty}?"),
    }
}

/// An operation's description without its usage plan. `clients::rate` reads that.
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

/// Amazon's links as Markdown's, and its bold spelled one way.
fn links(text: &str) -> String {
    static QUOTED: LazyLock<Regex> =
        LazyLock::new(|| regex(r#"<a href=['"]([^'"]+)['"]>([^<]+)</a>"#));
    static BARE: LazyLock<Regex> = LazyLock::new(|| regex(r"<a href=([^\s>]+)>([^<]+)</a>"));
    static BOLD: LazyLock<Regex> = LazyLock::new(|| regex(r"__([^\n]*?)__"));
    static DOC: LazyLock<Regex> = LazyLock::new(|| regex(r"\[([^\[\]]+)\]\(doc:([^()\s]+)\)"));
    let text = QUOTED.replace_all(text, "[$2]($1)");
    let text = BARE.replace_all(&text, "[$2]($1)");
    let text = BOLD.replace_all(&text, "**$1**");
    DOC.replace_all(
        &text,
        "[$1](https://developer-docs.amazon.com/sp-api/docs/$2)",
    )
}

/// What Ruby's `strip` leaves.
fn strip(text: &str) -> &str {
    text.trim_matches(|c: char| c.is_ascii_whitespace() || matches!(c, '\x0B' | '\0'))
}

/// An annotation's lines above a method. Those after the first are indented under it,
/// which is how an annotation goes on.
fn annotation(text: &str) -> Vec<String> {
    wrap(text, METHOD, 2)
}

/// A spec's text as comment lines. A line that starts with `@rbs` is an annotation
/// to Steep, and a spec is data: none of its lines starts with it. `wrap` keeps what
/// RDoc would read as a directive out of every line.
fn prose(text: &str, depth: usize) -> Vec<String> {
    let lines = wrap(text, depth, 0).into_iter();
    lines
        .map(|line| match line.strip_prefix("# @rbs") {
            Some(rest) => format!("# `@rbs{rest}"),
            None => line,
        })
        .collect()
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
            let line = format!("# {}{}", " ".repeat(margin), literal(&words.join(" ")));
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

/// A line of a spec's text as RDoc must read it: as text. RDoc takes a line that starts
/// with `:word:` for a directive, wherever in a comment it stands, and `:include: file`
/// puts that file on the page. `call-seq:` and `Document-method:` are directives without
/// the colon in front. A backslash makes each of them text again.
fn literal(line: &str) -> String {
    static DIRECTIVE: LazyLock<Regex> = LazyLock::new(|| regex(r"^:[\w-]+:"));
    if DIRECTIVE.find(line).is_some() {
        return format!("\\{line}");
    }
    for name in ["call-seq", "Document-method"] {
        let rest = line
            .strip_prefix(name)
            .and_then(|rest| rest.strip_prefix(':'));
        if let Some(rest) = rest {
            return format!("{name}\\:{rest}");
        }
    }
    line.to_owned()
}

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::json;

    /// An operation that takes 1 argument, with the same text wherever a spec has any.
    fn described(text: &str, name: &str) -> (Value, Operation) {
        let info = json!({"title": text, "description": text, "version": text});
        let parameter = Parameter {
            name: "id".into(),
            wire_name: "id".into(),
            position: 0,
            location: "query".into(),
            description: Some(text.into()),
            required: true,
            schema: json!({"type": "string"}),
            csv: false,
        };
        let op = Operation {
            id: "getThing".into(),
            name: name.into(),
            method: "GET".into(),
            path: "/things".into(),
            description: text.into(),
            rate: None,
            sandbox: Some("static"),
            parameters: vec![parameter],
            successes: Vec::new(),
        };
        (info, op)
    }

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
        let (info, op) = described(hostile, "get_thing\nexit 15");
        let api = &crate::manifest::ALL_APIS[0];
        let comments = [
            class(api, &info),
            accessor("Thing", &info),
            latest("Thing", "thing_v1"),
            operation(&op),
            pages(&op, "String id"),
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

    #[test]
    fn a_spec_never_writes_a_directive() {
        // What RDoc reads as a directive: a line that starts with `:word:`, or with
        // `call-seq:` or `Document-method:`. `:include:` would put a file on the built
        // page and `:stopdoc:` hide the rest of a class. Here each starts the text, a
        // paragraph, a line after a note, and every line a wrap begins.
        let hostile = format!(
            ":include: /etc/passwd.\n:stopdoc:\ncall-seq: hijacked(a).\n**Note:** x\n\n:nodoc: all.\nDocument-method: x.\n{}",
            ":include:secret.txt ".repeat(40)
        );
        let (info, op) = described(&hostile, "get_thing");
        let api = &crate::manifest::ALL_APIS[0];
        let comments = [
            class(api, &info),
            accessor("Thing", &info),
            operation(&op),
            pages(&op, "String id"),
        ];
        static DIRECTIVE: LazyLock<Regex> =
            LazyLock::new(|| regex(r"^#[\s]*(:[\w-]+:|call-seq:|Document-method:)"));
        for comment in &comments {
            for line in comment.lines() {
                assert!(DIRECTIVE.find(line.trim_start()).is_none(), "{line:?}");
            }
        }
        // The text is all there, each line behind the backslash that makes RDoc print it.
        let operation = operation(&op);
        for escaped in [
            "      # \\:include: /etc/passwd.\n",
            "      # \\:stopdoc:\n",
            "      # call-seq\\: hijacked(a).\n",
            "      # \\:nodoc: all.\n",
            "      # Document-method\\: x.\n",
            // A line a wrap begins, in the description and under the annotation.
            "      # \\:include:secret.txt :include:secret.txt",
            "      #   \\:include:secret.txt :include:secret.txt",
        ] {
            assert!(operation.contains(escaped), "{escaped:?} in {operation}");
        }
    }

    #[test]
    fn the_comment_of_a_pages_method_says_what_the_rate_applies_to() {
        let (_, op) = described("Lists things.", "list_things");
        assert_eq!(
            pages(&op, "String id"),
            concat!(
                "      # Each page of #list_things. `rate_limit` applies to every page.\n",
                "      #: (String id) -> Enumerator[Response, void]\n",
            )
        );
    }

    #[test]
    fn a_spec_never_writes_an_annotation() {
        // What Steep reads as an annotation: a line that starts with `@rbs`. Here it
        // starts the text, a paragraph, a comment and every line a wrap begins.
        let hostile = format!(
            "@rbs return: untyped.\n@rbs skip.\n# @rbs id: untyped.\n**Note:** x\n@rbs!\n{}",
            "@rbs ".repeat(60)
        );
        let (info, op) = described(&hostile, "get_thing");
        let api = &crate::manifest::ALL_APIS[0];
        // Each line that starts an annotation, up to its description.
        let annotations = |comment: &str| -> Vec<String> {
            let lines = comment.lines().map(str::trim_start);
            lines
                .filter(|line| {
                    let text = line.strip_prefix("# ").or(line.strip_prefix('#'));
                    line.starts_with("#:") || text.is_some_and(|text| text.starts_with("@rbs"))
                })
                .map(|line| line.split(" -- ").next().unwrap_or_default().to_owned())
                .collect()
        };
        assert!(class(api, &info).contains(
            "    # `@rbs return: untyped.\n    # `@rbs skip.\n    # `@rbs id: untyped.\n"
        ));
        assert_eq!(annotations(&class(api, &info)), [""; 0]);
        assert_eq!(
            annotations(&accessor("Thing", &info)),
            ["#: () -> Native::Thing"]
        );
        assert_eq!(
            annotations(&pages(&op, "String id")),
            ["#: (String id) -> Enumerator[Response, void]"]
        );
        // The argument's description goes on under its own annotation, indented.
        assert_eq!(
            annotations(&operation(&op)),
            [
                "# @rbs id: String",
                "# @rbs rate_limit: (Float | Integer)?",
                "# @rbs return: Response"
            ]
        );
    }
}
