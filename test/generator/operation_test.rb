# frozen_string_literal: true

require "helper"
require "generator/operation"

module Generator
  class OperationTest < Minitest::Test
    def setup
      @path = Minitest::Mock.new
      @path.expect(:parameters, [])
      @path.expect(:has_dynamic_sandbox?, false)
      @path.expect(:sandbox_only?, false)
    end

    def test_formats_special_sections_with_blank_lines
      test_cases = [
        {
          description: "This is a test operation. **Note:** This is an important note about the operation.",
          expected: "# This is a test operation.\n      #\n      # **Note:** This is an important note",
          label: "Note section",
        },
        {
          description: "This is a test operation. **Examples:** Here are some examples.",
          expected: "# This is a test operation.\n      #\n      # **Examples:** Here are some examples",
          label: "Examples section",
        },
        {
          description: "This is a test operation. **Note:** This is a note. **Examples:** Here are examples.",
          expected: "# This is a test operation.\n      #\n      # **Note:** This is a note.\n      #\n      # **Examples:** Here are examples",
          label: "Both Note and Examples",
        },
      ]

      test_cases.each do |test_case|
        operation_data = {
          "operationId" => "testOperation",
          "description" => test_case[:description],
          "parameters" => [],
        }

        operation = Generator::Operation.new(@path, "get", operation_data, "test_api_v0")
        description = operation.description

        assert_includes(
          description,
          test_case[:expected],
          "Failed for #{test_case[:label]}: expected special section with blank line before",
        )
      end
    end

    def test_handles_literal_newlines_in_description
      operation_data = {
        "operationId" => "testOperation",
        "description" => "Line one.\\n\\nLine two.\\n\\n**Note:** This is a note.",
        "parameters" => [],
      }

      operation = Generator::Operation.new(@path, "get", operation_data, "test_api_v0")
      description = operation.description

      assert_includes(description, "      # Line one.\n      #\n      # Line two.\n      #\n      # **Note:** This is a note")
    end

    def test_removes_usage_plan_section
      operation_data = {
        "operationId" => "testOperation",
        "description" => "This is a test operation.\\n\\n**Usage Plan:**\\n\\nRate limit details here",
        "parameters" => [],
      }

      operation = Generator::Operation.new(@path, "get", operation_data, "test_api_v0")
      description = operation.description

      refute_includes(description, "Usage Plan")
      refute_includes(description, "Rate limit details")
      assert_includes(description, "# This is a test operation")
    end

    def test_handles_complex_msku_encoding_description
      # This tests a real-world complex description from the fulfillment inbound API
      operation_data = {
        "operationId" => "listItemComplianceDetails",
        "description" => "List the inbound compliance details for MSKUs in a given marketplace.\\n\\n**Note:** MSKUs that contain certain characters must be encoded. For more information, refer to [URL Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).\\n\\nThe following characters must be double percent encoded:\\n\\n- `%`\\n- `+`\\n- `,`\\n\\n**Examples:** An MSKU value of `test%msku` is encoded as `test%2525msku`. An MSKU value of `test,msku` is encoded as `test%252Cmsku`.\\n\\n**Usage Plan:**\\n\\n| Rate (requests per second) | Burst |\\n| ---- | ---- |\\n| n | n |",
        "parameters" => [],
      }

      operation = Generator::Operation.new(@path, "get", operation_data, "test_api_v0")
      description = operation.description

      # Should have the main description
      assert_includes(description, "# List the inbound compliance details")

      # **Note:** and **Examples:** should be formatted with blank lines before
      assert_includes(description, "\n      #\n      # **Note:** MSKUs that contain")
      assert_includes(description, "\n      #\n      # **Examples:** An MSKU value")
    end

    def test_removes_usage_plan_from_complex_description
      operation_data = {
        "operationId" => "listItemComplianceDetails",
        "description" => "Description here.\\n\\n**Usage Plan:**\\n\\n| Rate (requests per second) | Burst |\\n| ---- | ---- |\\n| n | n |",
        "parameters" => [],
      }

      operation = Generator::Operation.new(@path, "get", operation_data, "test_api_v0")
      description = operation.description

      # Usage Plan should be removed
      refute_includes(description, "Usage Plan")
    end

    def test_parameter_with_array_default
      operation_data = {
        "operationId" => "searchCatalogItems",
        "description" => "Search for items",
        "parameters" => [
          {
            "name" => "includedData",
            "in" => "query",
            "type" => "array",
            "required" => false,
            "default" => "summaries",
          },
        ],
      }

      operation = Generator::Operation.new(@path, "get", operation_data, "test_api_v0")
      method_def = operation.method_definition

      assert_includes(method_def, 'included_data: ["summaries"]')
    end
  end
end
