# frozen_string_literal: true

require "helper"
require "generator/rbs/types"
require "generator/type"

module Generator
  module RBS
    class TypesTest < Minitest::Test
      API_NAME = "test_api_v1"

      def test_generates_consolidated_file
        type1 = create_mock_type("TypeOne", "class TypeOne < ::Data\nend")
        type2 = create_mock_type("TypeTwo", "class TypeTwo < ::Data\nend")

        types = [type1, type2]
        generator = Types.new(API_NAME, types)
        output_path = File.join(Generator::Config::BASE_PATH, "sig/peddler/types/#{API_NAME}.rbs")

        begin
          generator.generate

          assert_path_exists(output_path, "Consolidated RBS file should be created")
        ensure
          File.delete(output_path) if File.exist?(output_path)
        end
      end

      def test_includes_module_structure
        type1 = create_mock_type("TypeOne", "class TypeOne < ::Data\nend")
        type2 = create_mock_type("TypeTwo", "class TypeTwo < ::Data\nend")

        types = [type1, type2]
        generator = Types.new(API_NAME, types)
        output_path = File.join(Generator::Config::BASE_PATH, "sig/peddler/types/#{API_NAME}.rbs")

        begin
          generator.generate
          content = File.read(output_path)

          assert_match(/module Peddler/, content)
          assert_match(/module Types/, content)
          assert_match(/module TestApiV1/, content)
        ensure
          File.delete(output_path) if File.exist?(output_path)
        end
      end

      def test_includes_type_classes
        type1 = create_mock_type("TypeOne", "class TypeOne < ::Data\nend")
        type2 = create_mock_type("TypeTwo", "class TypeTwo < ::Data\nend")

        types = [type1, type2]
        generator = Types.new(API_NAME, types)
        output_path = File.join(Generator::Config::BASE_PATH, "sig/peddler/types/#{API_NAME}.rbs")

        begin
          generator.generate
          content = File.read(output_path)

          assert_match(/class TypeOne < ::Data/, content)
          assert_match(/class TypeTwo < ::Data/, content)
        ensure
          File.delete(output_path) if File.exist?(output_path)
        end
      end

      def test_uses_single_module_block
        type1 = create_mock_type("TypeOne", "class TypeOne < ::Data\nend")
        type2 = create_mock_type("TypeTwo", "class TypeTwo < ::Data\nend")

        types = [type1, type2]
        generator = Types.new(API_NAME, types)
        output_path = File.join(Generator::Config::BASE_PATH, "sig/peddler/types/#{API_NAME}.rbs")

        begin
          generator.generate
          content = File.read(output_path)

          assert_equal(1, content.scan("module Peddler").count)
          assert_equal(1, content.scan("module Types").count)
          assert_equal(1, content.scan("module TestApiV1").count)
        ensure
          File.delete(output_path) if File.exist?(output_path)
        end
      end

      def test_proper_indentation
        type = create_mock_type("TestType", "class TestType < ::Data\n  attr_reader name: String?\nend")

        generator = Types.new(API_NAME, [type])
        output_path = File.join(Generator::Config::BASE_PATH, "sig/peddler/types/#{API_NAME}.rbs")

        begin
          generator.generate
          content = File.read(output_path)

          # Check that class definition is indented with 6 spaces
          assert_match(/^      class TestType < ::Data/, content)
          # Check that attributes are indented with 8 spaces
          assert_match(/^        attr_reader name: String\?/, content)
        ensure
          File.delete(output_path) if File.exist?(output_path)
        end
      end

      def test_includes_generated_notice
        type = create_mock_type("TestType", "class TestType < ::Data\nend")

        generator = Types.new(API_NAME, [type])
        output_path = File.join(Generator::Config::BASE_PATH, "sig/peddler/types/#{API_NAME}.rbs")

        begin
          generator.generate
          content = File.read(output_path)

          assert_match(/# This file is generated/, content)
        ensure
          File.delete(output_path) if File.exist?(output_path)
        end
      end

      def test_sorts_types_alphabetically
        # Create types in reverse alphabetical order
        type_z = create_mock_type("ZebraType", "class ZebraType < ::Data\nend")
        type_m = create_mock_type("MonkeyType", "class MonkeyType < ::Data\nend")
        type_a = create_mock_type("AppleType", "class AppleType < ::Data\nend")

        types = [type_z, type_m, type_a]
        generator = Types.new(API_NAME, types)
        output_path = File.join(Generator::Config::BASE_PATH, "sig/peddler/types/#{API_NAME}.rbs")

        begin
          generator.generate
          content = File.read(output_path)

          # Find positions of each class
          apple_pos = content.index("class AppleType")
          monkey_pos = content.index("class MonkeyType")
          zebra_pos = content.index("class ZebraType")

          # Verify alphabetical order
          assert_operator(apple_pos, :<, monkey_pos, "AppleType should come before MonkeyType")
          assert_operator(monkey_pos, :<, zebra_pos, "MonkeyType should come before ZebraType")
        ensure
          File.delete(output_path) if File.exist?(output_path)
        end
      end

      private

      def create_mock_type(name, rbs_class_definition)
        type = Minitest::Mock.new
        type.expect(:class_name, name)
        type.expect(:rbs_class_definition, rbs_class_definition)
        type
      end
    end
  end
end
