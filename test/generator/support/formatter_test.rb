# frozen_string_literal: true

require "helper"
require "generator/support/formatter"

module Generator
  class FormatterTest < Minitest::Test
    include Generator::Formatter

    def test_split_long_comment_line
      line = "# This is a very long comment line."
      expected = "# This is a very\n# long comment line."

      assert_equal(expected, split_long_comment_line(line, max_line_length: 20))

      line = "#Short comment."
      expected = "# Short comment."

      assert_equal(expected, split_long_comment_line(line))

      line = "#"
      expected = "#"

      assert_equal(expected, split_long_comment_line(line))
    end

    # What RDoc reads as a directive: a line that starts with `:word:`, or with `call-seq:` or `Document-method:`.
    # `:include:` would put a file on the built page, and `:stopdoc:` hide the rest of a class. A spec is data.
    def test_a_spec_never_writes_a_directive
      text = ":include: /etc/passwd.\n:stopdoc:\ncall-seq: hijacked(a).\n\nDocument-method: x.\nSee :nodoc: here."
      expected = [
        "# \\:include: /etc/passwd.",
        "# \\:stopdoc:",
        "# call-seq\\: hijacked(a).",
        "#",
        "# Document-method\\: x.",
        "# See :nodoc: here.",
      ].join("\n")

      assert_equal(expected, split_long_comment_line(text))
    end

    def test_a_line_that_a_wrap_begins_is_no_directive_either
      wrapped = split_long_comment_line(":include:secret.txt " * 8, base_indent: 4, max_line_length: 50)

      assert_operator(wrapped.lines.size, :>, 1)
      wrapped.each_line { |line| assert_match(/\A    # \\:include:secret\.txt/, line) }
    end

    def test_convert_doc_links_to_full_url
      text = "Refer to [API Documentation](doc:api-doc)."
      expected = "Refer to [API Documentation](https://developer-docs.amazon.com/sp-api/docs/api-doc)."

      assert_equal(expected, convert_doc_links_to_full_url(text))

      malformed = "[[[\\(doc:foo"

      assert_equal(malformed, convert_doc_links_to_full_url(malformed))
    end

    def test_convert_html_links_to_markdown
      text = 'Refer to <a href="https://example.com">Example</a>.'
      expected = "Refer to [Example](https://example.com)."

      assert_equal(expected, convert_html_links_to_markdown(text))
    end

    def test_convert_html_links_to_markdown_with_single_quotes
      text = "Refer to <a href='https://example.com'>Example</a>."
      expected = "Refer to [Example](https://example.com)."

      assert_equal(expected, convert_html_links_to_markdown(text))
    end

    def test_convert_html_links_to_markdown_with_iso_8601
      text = "Date in <a href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> format."
      expected = "Date in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format."

      assert_equal(expected, convert_html_links_to_markdown(text))
    end

    def test_convert_html_links_to_markdown_with_unquoted_href
      text = "Validated against <a href=http://json-schema.org/draft-04/schema>http://json-schema.org/draft-04/schema</a>."
      expected = "Validated against [http://json-schema.org/draft-04/schema](http://json-schema.org/draft-04/schema)."

      assert_equal(expected, convert_html_links_to_markdown(text))
    end

    def test_normalizes_markdown_bold_underscores_to_asterisks
      text = "__Note__: This is a test."
      expected = "**Note**: This is a test."

      assert_equal(expected, convert_html_links_to_markdown(text))
    end

    def test_preserves_markdown_bold_with_asterisks
      text = "**Note**: This is a test."
      expected = "**Note**: This is a test."

      assert_equal(expected, convert_html_links_to_markdown(text))
    end

    def test_normalizes_multiple_markdown_bold_patterns
      text = "__Note__ and **Warning** both appear here."
      expected = "**Note** and **Warning** both appear here."

      assert_equal(expected, convert_html_links_to_markdown(text))
    end

    def test_converts_links_and_normalizes_markdown_bold
      text = "__Note__: See <a href='https://example.com'>docs</a> for details."
      expected = "**Note**: See [docs](https://example.com) for details."

      assert_equal(expected, convert_html_links_to_markdown(text))
    end
  end
end
