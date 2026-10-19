//! The docs of the generated Rust. Most are spec text, which rustdoc must read as the text
//! it is, whatever it holds. Amazon's links to its docs are full URLs, as in Ruby.
use crate::GenerationError;
use proc_macro2::{Delimiter, Group, TokenStream, TokenTree};
use pulldown_cmark::{CodeBlockKind, Event, Options, Parser, Tag};

/// Every doc of a source as a `///` line for each of its lines. Of a doc of several
/// lines the formatter writes 1 block comment, and in a block comment rustc drops the `*`
/// that starts each line after the first when they all start with one.
pub(crate) fn lines(tokens: TokenStream) -> Result<TokenStream, GenerationError> {
    let tokens: Vec<TokenTree> = tokens.into_iter().collect();
    let mut output = TokenStream::new();
    let mut i = 0;
    while i < tokens.len() {
        // Docs that follow one another are 1 text to rustdoc, a line each.
        let mut docs = Vec::new();
        while let Some(text) = doc(&tokens[i..]) {
            docs.push(text);
            i += 2;
        }
        if !docs.is_empty() {
            for line in split(&docs.join("\n"))? {
                output.extend(quote::quote!(#[doc = #line]));
            }
            continue;
        }
        output.extend([match &tokens[i] {
            TokenTree::Group(group) => {
                let mut copy = Group::new(group.delimiter(), lines(group.stream())?);
                copy.set_span(group.span());
                TokenTree::Group(copy)
            }
            token => token.clone(),
        }]);
        i += 1;
    }
    Ok(output)
}

/// The text of the outer doc attribute that `tokens` start with: `#` and `[doc = "..."]`.
fn doc(tokens: &[TokenTree]) -> Option<String> {
    let [TokenTree::Punct(pound), TokenTree::Group(group), ..] = tokens else {
        return None;
    };
    if pound.as_char() != '#' || group.delimiter() != Delimiter::Bracket {
        return None;
    }
    let meta: syn::MetaNameValue = syn::parse2(group.stream()).ok()?;
    match meta.value {
        syn::Expr::Lit(syn::ExprLit {
            lit: syn::Lit::Str(text),
            ..
        }) if meta.path.is_ident("doc") => Some(text.value()),
        _ => None,
    }
}

/// A doc's lines, each one that isn't blank after a space, so that it reads `/// The`.
/// The text is what rustdoc reads: without the whitespace every line starts with, and
/// with a line feed for each line break, as Rust refuses a carriage return in a doc
/// comment.
fn split(text: &str) -> Result<Vec<String>, GenerationError> {
    let text = text.replace("\r\n", "\n").replace('\r', "\n");
    let lines: Vec<&str> = text.split('\n').collect();
    let blank = |line: &str| line.trim().is_empty();
    let indent = |line: &str| line.chars().take_while(|c| matches!(c, ' ' | '\t')).count();
    let lines_with_text = lines.iter().filter(|line| !blank(line));
    let common = lines_with_text.map(|line| indent(line)).min().unwrap_or(0);
    let lines = lines
        .iter()
        .map(|line| line.get(common..).unwrap_or_default());
    let text = inert(&crate::docs::doc_links(
        &lines.collect::<Vec<_>>().join("\n"),
    ))?;
    let lines = text.split('\n').map(|line| match blank(line) {
        true => String::new(),
        false => format!(" {line}"),
    });
    Ok(lines.collect())
}

/// The Markdown rustdoc reads.
const OPTIONS: Options = Options::ENABLE_TABLES
    .union(Options::ENABLE_FOOTNOTES)
    .union(Options::ENABLE_STRIKETHROUGH)
    .union(Options::ENABLE_TASKLISTS)
    .union(Options::ENABLE_SMART_PUNCTUATION);

/// A doc whose code blocks rustdoc won't compile and run as doctests: a fenced one is
/// marked `text`, and an indented one is fenced as `text`. The parser is rustdoc's, so
/// the blocks are the ones it finds. An indented block's lines keep their indent.
fn inert(text: &str) -> Result<String, GenerationError> {
    // Where to put what, from the end back so that each place is still where it was.
    let mut edits: Vec<(std::ops::Range<usize>, String)> = Vec::new();
    for (event, range) in Parser::new_ext(text, OPTIONS).into_offset_iter() {
        let Event::Start(Tag::CodeBlock(kind)) = event else {
            continue;
        };
        // The line the block starts on, and what of it stands before the block.
        let start = text[..range.start].rfind('\n').map_or(0, |i| i + 1);
        let end = text[range.start..]
            .find('\n')
            .map_or(text.len(), |i| range.start + i);
        match kind {
            // The info string is what follows the run of ` or ~ on the opening line.
            CodeBlockKind::Fenced(_) => {
                let fence = text[range.start..].chars().next().unwrap_or('`');
                let run = text[range.start..end].len()
                    - text[range.start..end].trim_start_matches(fence).len();
                edits.push((range.start + run..end, "text".into()));
            }
            // The fences stand where the block's container does, before its 4 columns of
            // indent. The opening one takes the first line's place in front of the block,
            // a list's marker with it: the block's lines go on after it with the marker
            // as spaces, as do the lines after the first already.
            CodeBlockKind::Indented => {
                let prefix = &text[start..range.start];
                let opening = outdent(prefix);
                let indent = &prefix[opening.len()..];
                // A marker that a tab separated from the block keeps a space after it.
                let opening = &match opening.chars().last() {
                    Some(c) if !c.is_whitespace() && c != '>' => format!("{opening} "),
                    _ => opening.to_owned(),
                };
                let rest: String = opening
                    .chars()
                    .map(|c| {
                        if c == '>' || c.is_whitespace() {
                            c
                        } else {
                            ' '
                        }
                    })
                    .collect();
                let close = if text[..range.end].ends_with('\n') {
                    format!("{rest}```\n")
                } else {
                    format!("\n{rest}```")
                };
                edits.push((range.end..range.end, close));
                edits.push((
                    start..range.start,
                    format!("{opening}```text\n{rest}{indent}"),
                ));
            }
        }
    }
    edits.sort_by_key(|(range, _)| std::cmp::Reverse(range.start));
    let mut text = text.to_owned();
    for (range, replacement) in edits {
        text.replace_range(range, &replacement);
    }
    // What the parser finds in the result is the proof: a doc that would still run is
    // refused, and none is written.
    if runs(&text) {
        return Err(GenerationError(format!(
            "a doc holds a code block that can't be made text: {text:?}"
        )));
    }
    Ok(text)
}

/// Whether the parser finds a code block in a doc that isn't marked `text`.
fn runs(text: &str) -> bool {
    Parser::new_ext(text, OPTIONS).any(|event| match event {
        Event::Start(Tag::CodeBlock(CodeBlockKind::Fenced(info))) => info.as_ref() != "text",
        Event::Start(Tag::CodeBlock(CodeBlockKind::Indented)) => true,
        _ => false,
    })
}

/// What stands before an indented code block on its line, less the 4 columns of indent
/// that make it one. A tab is 4 columns at most.
fn outdent(prefix: &str) -> &str {
    let mut columns = 0;
    let mut rest = prefix;
    while columns < 4 {
        match rest.chars().last() {
            Some(' ') => columns += 1,
            Some('\t') => columns = 4,
            _ => break,
        }
        rest = &rest[..rest.len() - 1];
    }
    rest
}

#[cfg(test)]
mod tests {
    use super::*;

    fn format(source: &str) -> String {
        crate::format_source(source).unwrap()
    }

    /// Of a block comment rustc would read `*Note**:`, and a model's doc came as one.
    #[test]
    fn a_doc_is_a_line_comment_for_each_line() {
        let source = format(concat!(
            "#[doc = \"A field.\\n\\n**Note**: slowly.\"]\n",
            "#[derive(Debug)]\n",
            "pub struct A { #[doc = \"x\\r\\ny\\rz\"] #[serde(rename = \"b\")] pub b: u8 }",
        ));
        assert_eq!(
            source,
            concat!(
                "/// A field.\n",
                "///\n",
                "/// **Note**: slowly.\n",
                "#[derive(Debug)]\n",
                "pub struct A {\n",
                "    /// x\n",
                "    /// y\n",
                "    /// z\n",
                "    #[serde(rename = \"b\")]\n",
                "    pub b: u8,\n",
                "}\n",
            )
        );
    }

    /// Docs that follow one another are 1 text, as rustdoc reads them. Other attributes
    /// stay as they are.
    #[test]
    fn docs_in_a_row_are_1_text() {
        let source = format("#[doc = \"a\"] #[doc = \"b\\nc\"] #[doc(hidden)] fn f() {}");
        assert_eq!(source, "/// a\n/// b\n/// c\n#[doc(hidden)]\nfn f() {}\n");
    }

    /// Amazon's `doc:` links go nowhere outside its site.
    #[test]
    fn a_link_to_amazons_docs_is_a_full_url() {
        let source = format(concat!(
            "#[doc = \"See the [guide](doc:tokens-api-use-case-guide) and \"]\n",
            "#[doc = \"[step 7](doc:feeds-guide#step-7), not doc:bare or [x](doc: y).\"]\n",
            "fn f() {}",
        ));
        assert_eq!(
            source,
            concat!(
                "/// See the [guide](https://developer-docs.amazon.com/sp-api/docs/tokens-api-use-case-guide) and\n",
                "/// [step 7](https://developer-docs.amazon.com/sp-api/docs/feeds-guide#step-7), not doc:bare or [x](doc: y).\n",
                "fn f() {}\n",
            )
        );
    }

    /// A line reads `/// The`. rustdoc takes away the whitespace all lines start with,
    /// so what a line has more than the others stays, and a doc written that way already
    /// stays as it is.
    #[test]
    fn a_line_starts_after_a_space() {
        let source = format("#[doc = \"A list:\\n  - item\\n\\n    code\\n \\t\"] fn f() {}");
        assert_eq!(
            source,
            "/// A list:\n///   - item\n///\n///     code\n///\nfn f() {}\n"
        );
        assert_eq!(format(&source), source);
        let indented = format("#[doc = \"  a\\n    b\"] fn f() {}");
        assert_eq!(indented, "/// a\n///   b\nfn f() {}\n");
    }

    /// Each kind of code block rustdoc would run, and where it stands.
    const PLANTED: [&str; 14] = [
        "Fenced:\n\n```\npanic!(\"a spec ran\");\n```",
        "Fenced as Rust:\n\n```rust\npanic!(\"a spec ran\");\n```\nAfter.",
        "With tildes:\n\n~~~\npanic!(\"a spec ran\");\n~~~",
        "- In a list:\n\n  ```\n  panic!(\"a spec ran\");\n  ```",
        "1. In a list\n   - in a list:\n\n     ````\n     panic!(\"a spec ran\");\n     ````",
        "Indented:\n\n    panic!(\"a spec ran\");\n\n    panic!(\"a spec ran\");\nAfter.",
        "- Indented in a list:\n\n      panic!(\"a spec ran\");",
        "> Indented in a quote:\n>\n>     panic!(\"a spec ran\");\n> After.",
        "# Indented after a heading\n    panic!(\"a spec ran\");",
        "Indented at the end:\n\n\tpanic!(\"a spec ran\");",
        "Indented in a list item of its own:\n\n-     panic!(\"a spec ran\");",
        "Indented in a numbered one:\n\n1.     panic!(\"a spec ran\");\n\n       panic!(\"a spec ran\");",
        "Indented in a quote's list:\n\n> -     panic!(\"a spec ran\");",
        "Indented after a tab in a list item:\n\n-\t  panic!(\"a spec ran\");",
    ];

    /// What rustdoc's doctests of a source say, and whether they pass.
    fn doctests(source: &str) -> (bool, String) {
        let directory = tempfile::tempdir().unwrap();
        let path = directory.path().join("planted.rs");
        std::fs::write(&path, source).unwrap();
        let rustdoc = std::env::var("RUSTDOC").unwrap_or_else(|_| "rustdoc".into());
        let output = std::process::Command::new(rustdoc)
            .args(["--test", "--edition", "2024", "--crate-type", "lib"])
            .arg(&path)
            .current_dir(directory.path())
            .output()
            .unwrap();
        let text = String::from_utf8_lossy(&output.stdout).into_owned();
        (output.status.success(), text)
    }

    /// A spec is data: a code block in it is text, which rustdoc doesn't run.
    #[test]
    fn a_code_block_in_a_doc_never_runs() {
        let source: String = PLANTED
            .iter()
            .enumerate()
            .map(|(i, text)| format!("#[doc = {text:?}] pub struct Planted{i};\n"))
            .collect();
        // As the spec has it, each block runs and fails.
        let (passed, output) = doctests(&source);
        assert!(!passed, "{output}");
        assert!(output.contains("14 failed"), "{output}");
        // As the crate has it, none runs.
        let formatted = format(&source);
        let (passed, output) = doctests(&formatted);
        assert!(
            passed && output.contains("running 0 tests"),
            "{output}{formatted}"
        );
    }

    /// A fenced block keeps its fence and gets `text` for its info string. An indented
    /// one is fenced where its container stands, and keeps its lines.
    #[test]
    fn a_code_block_is_marked_text() {
        for (planted, expected) in [
            (
                PLANTED[1],
                "Fenced as Rust:\n\n```text\npanic!(\"a spec ran\");\n```\nAfter.",
            ),
            (
                PLANTED[2],
                "With tildes:\n\n~~~text\npanic!(\"a spec ran\");\n~~~",
            ),
            (
                PLANTED[3],
                "- In a list:\n\n  ```text\n  panic!(\"a spec ran\");\n  ```",
            ),
            (
                PLANTED[5],
                "Indented:\n\n```text\n    panic!(\"a spec ran\");\n\n    panic!(\"a spec ran\");\n```\nAfter.",
            ),
            (
                PLANTED[6],
                "- Indented in a list:\n\n  ```text\n      panic!(\"a spec ran\");\n  ```",
            ),
            (
                PLANTED[7],
                "> Indented in a quote:\n>\n> ```text\n>     panic!(\"a spec ran\");\n> ```\n> After.",
            ),
            (
                PLANTED[9],
                "Indented at the end:\n\n```text\n\tpanic!(\"a spec ran\");\n```",
            ),
            // A list's marker stays on the fence alone. On a line of its own, it would
            // start an item whose block runs.
            (
                PLANTED[10],
                "Indented in a list item of its own:\n\n- ```text\n      panic!(\"a spec ran\");\n  ```",
            ),
            (
                PLANTED[11],
                "Indented in a numbered one:\n\n1. ```text\n       panic!(\"a spec ran\");\n\n       panic!(\"a spec ran\");\n   ```",
            ),
            (
                PLANTED[12],
                "Indented in a quote's list:\n\n> - ```text\n>       panic!(\"a spec ran\");\n>   ```",
            ),
            // Inline code and a lazy line are no blocks.
            (
                "Use ```/orders```.\n\n- ```/a``` or\n    lazy",
                "Use ```/orders```.\n\n- ```/a``` or\n    lazy",
            ),
        ] {
            assert_eq!(inert(planted).unwrap(), expected, "{planted:?}");
        }
    }

    /// A tab after a list's marker is the space the fence needs after it too.
    #[test]
    fn a_marker_keeps_a_space_before_the_fence() {
        assert_eq!(
            inert(PLANTED[13]).unwrap(),
            "Indented after a tab in a list item:\n\n- ```text\n  \t  panic!(\"a spec ran\");\n  ```"
        );
    }

    /// The proof `inert` asks of its result: no block that rustdoc would compile.
    #[test]
    fn only_a_text_block_is_inert() {
        for planted in PLANTED {
            assert!(runs(planted), "{planted:?}");
            assert!(!runs(&inert(planted).unwrap()), "{planted:?}");
        }
        assert!(runs("```json\n{}\n```"));
        assert!(!runs("```text\nx\n```\n\nUse ```/orders```."));
    }
}
