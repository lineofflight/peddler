# frozen_string_literal: true

require "helper"
require "generator/api"
require "tempfile"

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

    def test_type_names
      assert_equal(["TestItem", "TestResponse"], @api.type_names)
    end

    def test_type_names_excludes_money
      spec_with_money = @test_spec.dup
      spec_with_money["definitions"]["Money"] = {
        "type" => "object",
        "properties" => {
          "currencyCode" => { "type" => "string" },
          "amount" => { "type" => "string" },
        },
      }

      temp_file = Tempfile.new(["with-money", ".json"])
      temp_file.write(spec_with_money.to_json)
      temp_file.rewind

      api = API.new(temp_file.path)

      refute_includes(api.type_names, "Money")

      temp_file.close
      temp_file.unlink
    end

    def test_operations_count
      assert_equal(2, @api.operations.size)
    end

    def test_operations_have_correct_operation_ids
      operation_ids = @api.operations.map(&:operation_id)

      assert_includes(operation_ids, "getTest")
      assert_includes(operation_ids, "getTestById")
    end

    def test_paths
      assert_equal(2, @api.paths.size)
      # Path objects have a path attribute
      paths = @api.paths

      assert(paths.any? { |p| p.path == "/test" })
      # Path class converts {id} to #{percent_encode(id)}
      assert(paths.any? { |p| p.path == "/test/\#{percent_encode(id)}" })
    end

    def test_has_helper
      # Should return false for our test API
      refute_predicate(@api, :has_helper?)
    end

    def test_helper_class_name
      assert_match(/^Peddler::Helpers::.*20240101$/, @api.helper_class_name)
    end

    def test_helper_library_name
      assert_match(%r{^peddler/helpers/.*_2024_01_01$}, @api.helper_library_name)
    end

    def test_github_model_filename
      # Filename is based on the actual temp file name
      assert_match(/\.json$/, @api.github_model_filename)
    end

    def test_duplicate_operation_handling
      spec_with_duplicate = @test_spec.dup
      # Add a duplicate operation with different HTTP verb
      spec_with_duplicate["paths"]["/test"]["post"] = {
        "operationId" => "getTest", # Same operationId as GET
        "description" => "Post test data",
        "responses" => { "200" => { "description" => "Success" } },
      }

      temp_file = Tempfile.new(["duplicate", ".json"])
      temp_file.write(spec_with_duplicate.to_json)
      temp_file.rewind

      api = API.new(temp_file.path)

      # Suppress logger output during this test
      old_level = Generator.logger.level
      Generator.logger.level = Logger::ERROR

      # Should raise an error for unhandled duplicates
      assert_raises(RuntimeError) do
        api.operations
      end
    ensure
      Generator.logger.level = old_level
      temp_file.close
      temp_file.unlink
    end

    def test_file_path
      assert_match(%r{lib/peddler/apis/.*_2024_01_01\.rb$}, @api.file_path)
    end

    def test_openapi_spec
      spec = @api.openapi_spec

      assert_equal("Test API", spec["info"]["title"])
      assert(spec["paths"])
      assert(spec["definitions"])
    end
  end
end
