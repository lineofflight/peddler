# frozen_string_literal: true

require "helper"
require "generator/report"

module Generator
  class ReportTest < Minitest::Test
    def setup
      @spec_path = File.join(Generator::Config::BASE_PATH, "selling-partner-api-models/schemas/reports")
      @account_health_spec = File.join(@spec_path, "accountHealthReport-2020-11-18.json")
      @b2b_spec = File.join(@spec_path, "b2bProductOpportunitiesNotYetOnAmazonReport-2020-11-19.json")

      @account_health = Generator::Report.new(@account_health_spec)
      @b2b_report = Generator::Report.new(@b2b_spec)
    end

    def test_root_properties_returns_hash
      properties = @account_health.root_properties

      assert_instance_of(Hash, properties)
      assert_predicate(properties.size, :positive?)
    end

    def test_root_required_properties_returns_array
      required = @account_health.root_required_properties

      assert_instance_of(Array, required)
    end

    def test_raw_description_returns_nil_for_generic_placeholder
      schema_with_placeholder = {
        "description" => "An explanation about the purpose of this instance.",
      }

      temp_file = Tempfile.new(["test-report", ".json"])
      temp_file.write(schema_with_placeholder.to_json)
      temp_file.rewind

      report = Generator::Report.new(temp_file.path)

      assert_nil(report.raw_description)

      temp_file.close
      temp_file.unlink
    end

    def test_nested_type_files_returns_array
      files = @account_health.nested_type_files

      assert_instance_of(Array, files)
      assert(files.all?(String))
    end

    def test_report_type_definition_structure
      type_def = @account_health.send(:report_type_definition)

      assert_equal("object", type_def["type"])
      assert_kind_of(Hash, type_def["properties"])
      assert_kind_of(Array, type_def["required"])
    end

    def test_report_type_definition_has_description
      type_def = @account_health.send(:report_type_definition)

      assert(type_def["description"])
    end
  end
end
