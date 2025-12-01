# frozen_string_literal: true

require "helper"
require "generator/notification"

module Generator
  class NotificationTest < Minitest::Test
    def setup
      @spec_path = File.join(Generator::Config::BASE_PATH, "selling-partner-api-models/schemas/notifications")
      @b2b_spec = File.join(@spec_path, "B2bAnyOfferChangedNotification.json")
      @any_offer_spec = File.join(@spec_path, "AnyOfferChangedNotification.json")

      # Suppress logger warnings during test setup (e.g., schema bug fixes)
      @original_logger_level = Generator.logger.level
      Generator.logger.level = Logger::ERROR

      @b2b_notification = Generator::Notification.new(@b2b_spec)
      @any_offer_notification = Generator::Notification.new(@any_offer_spec)

      Generator.logger.level = @original_logger_level
    end

    def test_wrapper_properties_returns_hash
      notification = @b2b_notification || @any_offer_notification

      properties = notification.wrapper_properties

      assert_instance_of(Hash, properties)
    end

    def test_envelope_properties_returns_hash
      notification = @b2b_notification || @any_offer_notification

      properties = notification.envelope_properties

      assert_instance_of(Hash, properties)
    end

    def test_payload_properties_returns_hash
      notification = @b2b_notification || @any_offer_notification

      properties = notification.payload_properties

      assert_instance_of(Hash, properties)
    end

    def test_wrapper_required_properties_returns_array
      notification = @b2b_notification || @any_offer_notification

      required = notification.wrapper_required_properties

      assert_instance_of(Array, required)
    end

    def test_nested_type_files_returns_array
      notification = @b2b_notification || @any_offer_notification

      files = notification.nested_type_files

      assert_instance_of(Array, files)
      assert(files.all?(String))
    end

    def test_notification_type_definition_structure
      notification = @b2b_notification || @any_offer_notification

      type_def = notification.send(:notification_type_definition)

      assert_equal("object", type_def["type"])
      assert_kind_of(Hash, type_def["properties"])
    end
  end
end
