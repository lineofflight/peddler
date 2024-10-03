# frozen_string_literal: true

require "minitest/autorun"
require "generator/formatter"

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
      expected = "Refer to {API Documentation https://developer-docs.amazon.com/sp-api/docs/api-doc}."

      assert_equal(expected, convert_doc_links_to_full_url(text))
    end

    def test_convert_html_links_to_yard
      text = 'Refer to <a href="https://example.com">Example</a>.'
      expected = "Refer to {Example https://example.com}."

      assert_equal(expected, convert_html_links_to_yard(text))
    end
  end
end
