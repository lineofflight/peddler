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

    def test_format_method_definition
      method_name = "example_method"
      params = ["param1", "param2", "param3"]
      expected = "def example_method(param1, param2, param3)"

      assert_equal(expected, format_method_definition(method_name, params))

      params = ["param1", "param2", "param3", "param4: nil", "param5: nil", "param6: nil"]
      expected = "def example_method(param1, param2, param3, param4: nil,\n  param5: nil, param6: nil)"

      assert_equal(expected, format_method_definition(method_name, params, max_line_length: 60))
    end

    def test_convert_doc_links_to_full_url
      text = "Refer to [API Documentation](doc:api-doc)."
      expected = "Refer to {https://developer-docs.amazon.com/sp-api/docs/api-doc API Documentation}."

      assert_equal(expected, convert_doc_links_to_full_url(text))
    end

    def test_convert_html_links_to_yard
      text = 'Refer to <a href="https://example.com">Example</a>.'
      expected = "Refer to {https://example.com Example}."

      assert_equal(expected, convert_html_links_to_yard(text))
    end

    def test_convert_html_links_to_yard_with_single_quotes
      text = "Refer to <a href='https://example.com'>Example</a>."
      expected = "Refer to {https://example.com Example}."

      assert_equal(expected, convert_html_links_to_yard(text))
    end

    def test_convert_html_links_to_yard_with_iso_8601
      text = "Date in <a href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> format."
      expected = "Date in {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format."

      assert_equal(expected, convert_html_links_to_yard(text))
    end

    def test_convert_html_links_to_yard_with_unquoted_href
      text = "Validated against <a href=http://json-schema.org/draft-04/schema>http://json-schema.org/draft-04/schema</a>."
      expected = "Validated against {http://json-schema.org/draft-04/schema http://json-schema.org/draft-04/schema}."

      assert_equal(expected, convert_html_links_to_yard(text))
    end

    def test_normalizes_markdown_bold_underscores_to_asterisks
      text = "__Note__: This is a test."
      expected = "**Note**: This is a test."

      assert_equal(expected, convert_html_links_to_yard(text))
    end

    def test_preserves_markdown_bold_with_asterisks
      text = "**Note**: This is a test."
      expected = "**Note**: This is a test."

      assert_equal(expected, convert_html_links_to_yard(text))
    end

    def test_normalizes_multiple_markdown_bold_patterns
      text = "__Note__ and **Warning** both appear here."
      expected = "**Note** and **Warning** both appear here."

      assert_equal(expected, convert_html_links_to_yard(text))
    end

    def test_converts_links_and_normalizes_markdown_bold
      text = "__Note__: See <a href='https://example.com'>docs</a> for details."
      expected = "**Note**: See {https://example.com docs} for details."

      assert_equal(expected, convert_html_links_to_yard(text))
    end
  end
end
