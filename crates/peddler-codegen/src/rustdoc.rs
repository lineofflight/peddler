//! The docs of the generated Rust. Most are spec text, which rustdoc must read as the text
//! it is, whatever it holds.
use proc_macro2::{Delimiter, Group, TokenStream, TokenTree};

/// Every doc of a source as a `///` line for each of its lines. Of a doc of several
/// lines the formatter writes 1 block comment, and in a block comment rustc drops the `*`
/// that starts each line after the first when they all start with one.
pub(crate) fn lines(tokens: TokenStream) -> TokenStream {
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
            for line in split(&docs.join("\n")) {
                output.extend(quote::quote!(#[doc = #line]));
            }
            continue;
        }
        output.extend([match &tokens[i] {
            TokenTree::Group(group) => {
                let mut copy = Group::new(group.delimiter(), lines(group.stream()));
                copy.set_span(group.span());
                TokenTree::Group(copy)
            }
            token => token.clone(),
        }]);
        i += 1;
    }
    output
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
/// rustdoc takes away the whitespace every line starts with, as it does here first. Rust
/// refuses a carriage return in a doc comment, so each line break is a line feed.
fn split(text: &str) -> Vec<String> {
    let text = text.replace("\r\n", "\n").replace('\r', "\n");
    let lines: Vec<&str> = text.split('\n').collect();
    let blank = |line: &str| line.trim().is_empty();
    let indent = |line: &str| line.chars().take_while(|c| matches!(c, ' ' | '\t')).count();
    let lines_with_text = lines.iter().filter(|line| !blank(line));
    let common = lines_with_text.map(|line| indent(line)).min().unwrap_or(0);
    lines
        .iter()
        .map(|line| match blank(line) {
            true => String::new(),
            false => format!(" {}", &line[common..]),
        })
        .collect()
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
}
