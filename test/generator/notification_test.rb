# frozen_string_literal: true

require "helper"
require "generator/notification"

module Generator
  class NotificationTest < Minitest::Test
    def setup
      @spec_path = File.join(Generator::Config::BASE_PATH, "selling-partner-api-models/schemas/notifications")
      @b2b_spec = File.join(@spec_path, "B2bAnyOfferChangedNotification.json")
      @any_offer_spec = File.join(@spec_path, "AnyOfferChangedNotification.json")

      return skip("Notification specs not found") unless File.exist?(@b2b_spec) || File.exist?(@any_offer_spec)

      # Suppress logger warnings during test setup (e.g., schema bug fixes)
      @original_logger_level = Generator.logger.level
      Generator.logger.level = Logger::ERROR

      @b2b_notification = Generator::Notification.new(@b2b_spec) if File.exist?(@b2b_spec)
      @any_offer_notification = Generator::Notification.new(@any_offer_spec) if File.exist?(@any_offer_spec)

      Generator.logger.level = @original_logger_level
    end

    def test_b2b_acronym_capitalization_in_class_name
      skip unless @b2b_notification

      # This tests that the generator produces correct B2B capitalization from the spec file name
      # The spec file is "B2bAnyOfferChangedNotification.json" but we want "B2BAnyOfferChanged"
      assert_equal(
        "B2BAnyOfferChanged",
        @b2b_notification.class_name,
        "B2B should be capitalized as an acronym in class name",
      )
    end

    def test_notification_name_extraction_from_filename
      skip unless @any_offer_notification

      # AnyOfferChangedNotification.json => AnyOfferChanged
      assert_equal("AnyOfferChanged", @any_offer_notification.notification_name)
    end

    def test_notification_name_removes_notification_suffix
      skip unless @any_offer_notification

      # Should not include "Notification" in the name
      refute_includes(@any_offer_notification.notification_name, "Notification")
    end

    def test_class_name_matches_notification_name
      skip unless @any_offer_notification

      # For notifications, class_name should match notification_name after camelization
      expected = @any_offer_notification.notification_name.underscore.camelize

      assert_equal(expected, @any_offer_notification.class_name)
    end

    def test_wrapper_properties_returns_hash
      notification = @b2b_notification || @any_offer_notification
      skip unless notification

      properties = notification.wrapper_properties

      assert_instance_of(Hash, properties)
    end

    def test_envelope_properties_returns_hash
      notification = @b2b_notification || @any_offer_notification
      skip unless notification

      properties = notification.envelope_properties

      assert_instance_of(Hash, properties)
    end

    def test_payload_properties_returns_hash
      notification = @b2b_notification || @any_offer_notification
      skip unless notification

      properties = notification.payload_properties

      assert_instance_of(Hash, properties)
    end

    def test_wrapper_required_properties_returns_array
      notification = @b2b_notification || @any_offer_notification
      skip unless notification

      required = notification.wrapper_required_properties

      assert_instance_of(Array, required)
    end

    def test_nested_type_files_returns_array
      notification = @b2b_notification || @any_offer_notification
      skip unless notification

      files = notification.nested_type_files

      assert_instance_of(Array, files)
      # All items should be strings (underscored type names)
      assert(files.all?(String))
    end

    def test_api_name_for_type_resolver
      skip unless @any_offer_notification

      # Private method but important for SchemaHelpers integration
      api_name = @any_offer_notification.send(:api_name_for_type_resolver)

      assert_equal("notifications/any_offer_changed", api_name)
    end

    def test_output_file_path
      skip unless @any_offer_notification

      file_path = @any_offer_notification.send(:output_file_path)

      assert_includes(file_path, "lib/peddler/notifications/any_offer_changed.rb")
    end

    def test_notification_type_definition_structure
      notification = @b2b_notification || @any_offer_notification
      skip unless notification

      type_def = notification.send(:notification_type_definition)

      assert_equal("object", type_def["type"])
      assert_kind_of(Hash, type_def["properties"])
    end

    def test_class_name_is_consistent
      notification = @b2b_notification || @any_offer_notification
      skip unless notification

      # Call multiple times to ensure consistency
      name1 = notification.class_name
      name2 = notification.class_name

      assert_equal(name1, name2)
    end
  end
end
