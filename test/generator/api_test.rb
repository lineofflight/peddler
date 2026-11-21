# frozen_string_literal: true

require "helper"
require "generator/api"
require "tempfile"
require "tmpdir"

module Generator
  class APITest < Minitest::Test
    def setup
      @test_spec = {
        "info" => {
          "title" => "Test API",
          "version" => "2024-01-01",
          "description" => "A test API for testing purposes",
        },
        "paths" => {
          "/test" => {
            "get" => {
              "operationId" => "getTest",
              "description" => "Get test data",
              "parameters" => [],
              "responses" => {
                "200" => {
                  "description" => "Success",
                  "schema" => {
                    "$ref" => "#/definitions/TestResponse",
                  },
                },
              },
            },
          },
          "/test/{id}" => {
            "get" => {
              "operationId" => "getTestById",
              "description" => "Get test by ID",
              "parameters" => [
                {
                  "name" => "id",
                  "in" => "path",
                  "required" => true,
                  "type" => "string",
                },
              ],
              "responses" => {
                "200" => {
                  "description" => "Success",
                },
              },
            },
          },
        },
        "definitions" => {
          "TestResponse" => {
            "type" => "object",
            "properties" => {
              "payload" => {
                "$ref" => "#/definitions/TestItem",
              },
            },
          },
          "TestItem" => {
            "type" => "object",
            "properties" => {
              "id" => { "type" => "string" },
              "name" => { "type" => "string" },
            },
          },
        },
      }

      @temp_file = Tempfile.new(["test-api-model", ".json"])
      @temp_file.write(@test_spec.to_json)
      @temp_file.rewind
      @api = API.new(@temp_file.path)
    end

    def teardown
      @temp_file.close
      @temp_file.unlink
    end

    def test_api_version_extraction
      assert_equal("2024_01_01", @api.version)
    end

    # The version comes from the spec, and goes into the name of a module and of a file. A spec is data.
    def test_a_version_that_is_no_identifier_is_refused
      file = Tempfile.new(["test-api-model", ".json"])
      file.write(@test_spec.merge("info" => { "version" => "1\"; exit 1; \"" }).to_json)
      file.rewind

      assert_raises(ArgumentError) { API.new(file.path).name_with_version }
    ensure
      file.close!
    end

    # An API is named after the directory of its spec, and that name goes into code as a module. It is data too.
    def test_an_api_named_after_a_hostile_directory_is_refused
      Dir.mktmpdir do |dir|
        file = File.join(dir, "x;exit 1;y-api-model", "spec.json")
        FileUtils.mkdir_p(File.dirname(file))
        File.write(file, @test_spec.to_json)

        assert_raises(ArgumentError) { API.new(file).class_name }
      end
    end

    def test_name_with_version
      # Name depends on file path structure
      assert_match(/_2024_01_01$/, @api.name_with_version)
    end

    def test_class_name
      # Class name is derived from name_with_version
      assert_match(/20240101$/, @api.class_name)
    end

    def test_library_name
      assert_match(%r{peddler/apis/.*_2024_01_01$}, @api.library_name)
    end

    def test_title_extraction
      assert_match(/Test API/, @api.title)
    end

    def test_description_extraction
      assert_match(/A test API for testing purposes/, @api.description)
    end

    def test_paths
      assert_equal(2, @api.paths.size)
    end

    def test_github_model_filename
      # Filename is based on the actual temp file name
      assert_match(/\.json$/, @api.github_model_filename)
    end

    def test_parsers_use_native_keys
      @api.define_singleton_method(:native_keys) do
        { ["/test", "GET"] => "test_2024_01_01.get_test" }
      end

      assert_equal({ "test_2024_01_01.get_test" => "TestResponse" }, @api.parsers)
    end

    def test_parsers_reject_operation_missing_from_inventory
      @api.define_singleton_method(:native_keys) { {} }

      assert_raises(RuntimeError) { @api.parsers }
    end

    def test_file_path
      assert_match(%r{lib/peddler/apis/.*_2024_01_01\.rb$}, @api.file_path)
    end
  end
end
