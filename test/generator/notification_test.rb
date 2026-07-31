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

    # Regression test for the "notification" entry in JsonSchemaExtractor's skip list:
    # a "Notification" definition must not be extracted as a nested type, or it
    # duplicates the top-level Notification class.
    #
    # No upstream schema currently has this shape. Amazon shipped it in July 2026 with
    # TaxInvoiceExportStatusChange and TaxInvoiceIssuanceStatus, then withdrew both a
    # day later. The guard and this test are kept in case those return; the fixture is
    # inline because pinning it to a live schema is what broke when they were withdrawn.
    def test_notification_with_root_notification_definition
      spec = {
        "$ref" => "#/definitions/Notification",
        "definitions" => {
          "Notification" => {
            "type" => "object",
            "properties" => {
              "notificationType" => { "type" => "string" },
              "notificationMetadata" => { "$ref" => "#/definitions/NotificationMetadata" },
              "payload" => { "$ref" => "#/definitions/Payload" },
            },
          },
          "NotificationMetadata" => {
            "type" => "object",
            "properties" => { "applicationId" => { "type" => "string" } },
          },
          "Payload" => {
            "type" => "object",
            "properties" => { "exportId" => { "type" => "string" } },
          },
        },
      }

      temp_file = Tempfile.new(["RootRefNotification", ".json"])
      temp_file.write(spec.to_json)
      temp_file.rewind

      files = Generator::Notification.new(temp_file.path).nested_type_files

      refute_includes(files, "notification")
      # Sibling definitions are still extracted, so the assertion above is not vacuous
      assert_includes(files, "notification_metadata")

      temp_file.close
      temp_file.unlink
    end
  end
end
