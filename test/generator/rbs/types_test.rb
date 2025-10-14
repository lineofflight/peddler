# frozen_string_literal: true

require "helper"
require "generator/rbs/types"
require "generator/type"

module Generator
  module RBS
    class TypesTest < Minitest::Test
      API_NAME = "notifications/test_notification"

      def test_generates_valid_rbs_content
        type1 = create_mock_type("TypeOne", "class TypeOne < ::Data\nend")
        type2 = create_mock_type("TypeTwo", "class TypeTwo < ::Data\nend")

        types = [type1, type2]
        generator = Types.new(API_NAME, types)
        content = generator.content

        # Verify it includes our types
        assert_match(/class TypeOne < ::Data/, content)
        assert_match(/class TypeTwo < ::Data/, content)
      end

      def test_wraps_types_in_correct_modules
        type1 = create_mock_type("TypeOne", "class TypeOne < ::Data\nend")

        types = [type1]
        generator = Types.new(API_NAME, types)
        content = generator.content

        assert_match(/module Peddler/, content)
        assert_match(/module Notifications/, content)
        assert_match(/module TestNotification/, content)
      end

      def test_sorts_types_alphabetically
        # Create types in reverse alphabetical order
        type_z = create_mock_type("ZebraType", "class ZebraType < ::Data\nend")
        type_m = create_mock_type("MonkeyType", "class MonkeyType < ::Data\nend")
        type_a = create_mock_type("AppleType", "class AppleType < ::Data\nend")

        types = [type_z, type_m, type_a]
        generator = Types.new(API_NAME, types)
        content = generator.content

        # Verify alphabetical order
        apple_pos = content.index("class AppleType")
        monkey_pos = content.index("class MonkeyType")
        zebra_pos = content.index("class ZebraType")

        assert_operator(apple_pos, :<, monkey_pos)
        assert_operator(monkey_pos, :<, zebra_pos)
      end

      private

      def create_mock_type(name, rbs_class_definition)
        # Use a simple object with methods instead of Mock
        # since class_name is called multiple times (sorting + finding)
        Struct.new(:class_name, :rbs_class_definition).new(name, rbs_class_definition)
      end
    end
  end
end
