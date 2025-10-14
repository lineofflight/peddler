# frozen_string_literal: true

require "helper"
require "generator/report"

module Generator
  class ReportTest < Minitest::Test
    def setup
      @spec_path = File.join(Generator::Config::BASE_PATH, "selling-partner-api-models/schemas/reports")
      @account_health_spec = File.join(@spec_path, "accountHealthReport-2020-11-18.json")
      @b2b_spec = File.join(@spec_path, "b2bProductOpportunitiesNotYetOnAmazonReport-2020-11-19.json")

      skip("Report specs not found") unless File.exist?(@account_health_spec)

      @account_health = Generator::Report.new(@account_health_spec)
      @b2b_report = Generator::Report.new(@b2b_spec) if File.exist?(@b2b_spec)
    end

    def test_report_name_extraction_from_filename
      # accountHealthReport-2020-11-18.json => accountHealthReport_2020_11_18
      # (Note: Report suffix not removed when followed by date)
      assert_equal("accountHealthReport_2020_11_18", @account_health.report_name)
    end

    def test_report_name_handles_dashes_in_name
      skip unless @b2b_report

      # b2bProductOpportunitiesNotYetOnAmazonReport-2020-11-19.json
      assert_equal("b2bProductOpportunitiesNotYetOnAmazonReport_2020_11_19", @b2b_report.report_name)
    end

    def test_class_name_camelizes_report_name
      # accountHealthReport_2020_11_18 => AccountHealthReport20201118
      assert_equal("AccountHealthReport20201118", @account_health.class_name)
    end

    def test_b2b_acronym_capitalization_in_class_name
      skip unless @b2b_report

      # Should capitalize B2B as acronym
      assert_includes(@b2b_report.class_name, "B2B")
    end

    def test_root_properties_returns_hash
      properties = @account_health.root_properties

      assert_instance_of(Hash, properties)
      assert_predicate(properties.size, :positive?)
    end

    def test_root_properties_are_sorted
      properties = @account_health.root_properties

      keys = properties.keys

      assert_equal(keys, keys.sort)
    end

    def test_root_required_properties_returns_array
      required = @account_health.root_required_properties

      assert_instance_of(Array, required)
    end

    def test_raw_description_returns_nil_for_generic_placeholder
      # Create a mock report with generic placeholder
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
      # All items should be strings (underscored type names)
      assert(files.all?(String))
    end

    def test_api_name_for_type_resolver
      # Private method but important for SchemaHelpers integration
      api_name = @account_health.send(:api_name_for_type_resolver)

      assert_equal("reports/account_health_report_2020_11_18", api_name)
    end

    def test_output_file_path
      file_path = @account_health.send(:output_file_path)

      assert_includes(file_path, "lib/peddler/reports/account_health_report_2020_11_18.rb")
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

    def test_class_name_is_consistent
      # Call multiple times to ensure consistency
      name1 = @account_health.class_name
      name2 = @account_health.class_name

      assert_equal(name1, name2)
    end
  end
end
