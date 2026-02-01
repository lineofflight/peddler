# frozen_string_literal: true

require "erb"
require "fileutils"
require "hana"
require "json"
require "parallel"

require_relative "support/logger"
require_relative "support/config"
require_relative "support/file_writer"
require_relative "support/schema_generator"
require_relative "support/introspection_loader"
require_relative "support/money_detector"
require_relative "parsers/json_schema_extractor"
require_relative "builders/type"
require_relative "support/schema_helpers"
require_relative "rbs/types"

module Generator
  # Generates Ruby type classes for SP-API notification payloads from JSON Schema files
  class Notification
    include FileWriter
    include SchemaHelpers
    include SchemaGenerator

    attr_reader :file_path, :schema

    class << self
      def schema_type
        "notifications"
      end
    end

    def initialize(file_path)
      @file_path = file_path
      @schema = JSON.parse(File.read(file_path))
      resolve_root_ref!
      apply_json_patch!
    end

    def generate
      written_files = []
      all_types = []

      # Generate nested types first
      nested_results = generate_nested_types!
      written_files.concat(nested_results[:files])
      all_types.concat(nested_results[:types])

      # Generate Payload and Notification as types
      payload_results = generate_payload_types!
      written_files.concat(payload_results[:files])
      all_types.concat(payload_results[:types])

      notification_result = generate_notification_type!
      written_files << notification_result[:file]
      all_types << notification_result[:type]

      # Generate main convenience file
      written_files << generate_main_file!

      # Reload to pick up newly generated files for RBS introspection
      IntrospectionLoader.reload
      written_files << generate_rbs!(all_types)

      # Batch format all written files
      format_files(written_files)

      Generator.logger.info("Generated notification #{notification_name.underscore}")
    end

    # Extract notification name from filename (e.g., "AnyOfferChangedNotification.json" => "AnyOfferChanged")
    def notification_name
      base_name = File.basename(file_path, ".json")
      # Remove "Notification" suffix but keep version suffix (e.g., "_2023-12-13")
      # Convert dashes in version suffix to underscores for valid Ruby identifiers
      base_name.sub(/Notification$/, "").tr("-", "_")
    end

    # Get the actual payload key name from the schema (handles PascalCase vs camelCase)
    def payload_key_name
      # Check if schema uses "payload" or "Payload"
      if schema.dig("properties", "payload")
        "payload"
      elsif schema.dig("properties", "Payload")
        "Payload"
      else
        "payload" # fallback
      end
    end

    # Get the actual notification object name within payload (handles casing variations)
    def notification_object_name
      payload = resolved_payload_schema
      return unless payload

      notification_object_candidates.find do |candidate|
        payload.dig("properties", candidate)
      end
    end

    # Class name for the notification (e.g., "AnyOfferChanged")
    def class_name
      # Underscore first to ensure ActiveSupport::Inflector applies acronym rules correctly
      notification_name.underscore.camelize
    end

    # Extract payload version from the schema examples or filename
    def payload_version
      # Try to get from examples first
      examples = schema.dig("examples")
      if examples&.first
        return examples.first["payloadVersion"] || examples.first["PayloadVersion"]
      end

      # Fall back to filename-based version (e.g., "_2023-12-13")
      if file_path =~ /_(\d{4}-\d{2}-\d{2})\.json$/
        matched = ::Regexp.last_match(1)
        return matched if matched
      end

      # Default to 1.0 if no version found
      "1.0"
    end

    # Properties from the wrapper level (notificationVersion, notificationType, etc.)
    def wrapper_properties
      sorted_properties(schema["properties"] || {})
    end

    # Required properties from the wrapper level
    def wrapper_required_properties
      schema["required"] || []
    end

    # Class description from schema (no leading spaces - template handles indentation)
    # Raw description from schema (will be formatted by Type class)
    def raw_description
      return unless schema["description"]
      return if generic_placeholder?(schema["description"])

      schema["description"]
    end

    # Detect if this is Type A (nested) or Type B (flat) notification
    def notification_type
      return :unknown unless resolved_payload_schema

      notification_object_schema ? :nested : :flat
    end

    # Get envelope properties (notificationVersion, notificationType, eventTime, etc.)
    def envelope_properties
      keys = %w[notificationVersion notificationType payloadVersion eventTime notificationMetadata]

      keys.flat_map { |key| [key, key.sub(/\A./, &:upcase)] }.each_with_object({}) do |key, props|
        prop = schema.dig("properties", key)
        props[key] = prop if prop
      end
    end

    # Get required envelope properties
    def envelope_required_properties
      required = schema["required"] || []
      envelope_keys = envelope_properties.keys
      required.select { |r| envelope_keys.include?(r) }
    end

    # Get payload schema (the full payload object)
    def payload_schema
      schema.dig("properties", "payload") || schema.dig("properties", "Payload")
    end

    # Get payload properties based on notification type
    def payload_properties
      payload = resolved_payload_schema
      return {} unless payload

      if notification_type == :nested
        nested_obj = notification_object_schema
        return sorted_properties(nested_obj["properties"] || {}) if nested_obj

        {}
      else
        # Type B: use payload properties directly
        sorted_properties(payload["properties"] || {})
      end
    end

    # Get required payload properties based on notification type
    def payload_required_properties
      payload = resolved_payload_schema
      return [] unless payload

      if notification_type == :nested
        nested_obj = notification_object_schema
        nested_obj ? (nested_obj["required"] || []) : []
      else
        # Type B: use payload required directly
        payload["required"] || []
      end
    end

    # Replace inline object definitions with $ref pointers to extracted types
    def replace_inline_objects_with_refs(properties, extracted_types)
      result = {}
      properties.each do |prop_name, prop_def|
        # Check if this is a money-like object
        if MoneyDetector.money_like?(prop_def)
          result[prop_name] = {
            "$ref" => "#/definitions/Money",
            "description" => prop_def["description"],
          }.compact
          next
        end

        # Check if this property matches an extracted type name
        if prop_def["type"] == "object" && extracted_types.key?(prop_name)
          # Replace with $ref
          result[prop_name] = { "$ref" => "#/definitions/#{prop_name}" }
        elsif prop_def["type"] == "array" && prop_def["items"]
          # Handle array items - check if they're objects that match extracted types
          items = prop_def["items"]

          # Handle case where items is an array (non-standard format)
          items = items.first if items.is_a?(Array) && !items.empty?

          # Check if items are money-like objects
          if items.is_a?(Hash) && MoneyDetector.money_like?(items)
            result[prop_name] = prop_def.dup
            result[prop_name]["items"] = { "$ref" => "#/definitions/Money" }
            next
          end

          # Check if items are inline objects that match extracted types
          if items.is_a?(Hash) && (items["type"] == "object" || items["anyOf"])
            item_type_name = prop_name.singularize
            if extracted_types.key?(item_type_name)
              result[prop_name] = prop_def.dup
              result[prop_name]["items"] = { "$ref" => "#/definitions/#{item_type_name}" }
            else
              result[prop_name] = prop_def
            end
          else
            result[prop_name] = prop_def
          end
        else
          result[prop_name] = prop_def
        end
      end
      result
    end

    private

    # Provide the name for schema extraction
    def name
      notification_name
    end

    def resolved_payload_schema
      payload = payload_schema
      return unless payload
      return payload unless payload["$ref"]

      ref_path = payload["$ref"].sub("#/definitions/", "")
      schema.dig("definitions", ref_path)
    end

    def notification_object_candidates
      [
        "#{notification_name.camelize(:lower)}Notification",
        "#{notification_name.camelize}Notification",
      ]
    end

    def notification_object_schema
      payload = resolved_payload_schema
      return unless payload

      name = notification_object_candidates.find { |candidate| payload.dig("properties", candidate) }
      return unless name

      nested = payload.dig("properties", name)
      return unless nested

      if nested["$ref"]
        ref_path = nested["$ref"].sub("#/definitions/", "")
        schema.dig("definitions", ref_path)
      else
        nested
      end
    end

    # Resolve root-level $ref or #ref if present
    # Some schemas (B2B, PricingHealth) use refs to shared notificationResponse
    def resolve_root_ref!
      ref = schema["$ref"] || schema["#ref"]
      return unless ref

      # Extract the definition name from the ref (e.g., "#/definitions/notificationResponse" => "notificationResponse")
      if ref.start_with?("#/definitions/")
        def_name = ref.sub("#/definitions/", "")
        resolved_schema = schema["definitions"]&.[](def_name)

        if resolved_schema
          # Merge the resolved schema while keeping definitions
          definitions = schema["definitions"]
          @schema = resolved_schema.merge("definitions" => definitions)
        end
      end
    end

    # Apply JSON Patch (RFC 6902) from per-notification patch files
    # This fixes Amazon schema bugs where optional fields are marked as required
    def apply_json_patch!
      patch_file = File.join(__dir__, "patches", "#{notification_name.underscore}.json")
      return unless File.exist?(patch_file)

      patch_data = JSON.parse(File.read(patch_file))
      patch = Hana::Patch.new(patch_data)
      @schema = patch.apply(schema)

      Generator.logger.warn("Applied JSON Patch from #{File.basename(patch_file)}")
    end

    def main_template
      File.read(Config.template_path("notification_main"))
    end

    # Build Payload type definition
    def payload_type_definition
      if notification_type == :nested
        notif_obj_name = notification_object_name
        raise "Missing notification object name for nested notification" unless notif_obj_name

        # For nested notifications, Payload wraps the nested notification object with a $ref
        {
          "type" => "object",
          "description" => "Notification payload that wraps nested notification data",
          "properties" => {
            notif_obj_name => {
              "$ref" => "#/definitions/#{notif_obj_name.camelize}",
            },
          },
          "required" => [notif_obj_name],
        }
      else
        # For flat notifications, Payload has properties directly
        {
          "type" => "object",
          "description" => "Notification payload data",
          "properties" => payload_properties,
          "required" => payload_required_properties,
        }
      end
    end

    # Build Notification type definition
    def notification_type_definition
      # Get payload property with its description from schema
      payload_property_def = schema.dig("properties", payload_key_name) || {}

      {
        "type" => "object",
        "description" => raw_description || "Notification envelope with metadata",
        "properties" => envelope_properties.merge({
          payload_key_name => {
            "$ref" => "#/definitions/Payload",
            "description" => payload_property_def["description"],
          }.compact,
        }),
        "required" => envelope_required_properties + [payload_key_name],
      }
    end

    def generate_payload_types!
      written_files = []
      type_instances = []

      # Build spec with all extracted types
      extractor = JsonSchemaExtractor.new(schema, notification_name)
      extracted_types = extractor.extract_types

      # For nested notifications, generate the nested notification object as a separate type
      if notification_type == :nested
        notif_obj_name = notification_object_name
        raise "Missing notification object name for nested notification" unless notif_obj_name

        # Check if this notification object was already extracted from schema definitions
        # If so, it was already generated in generate_nested_types! and we shouldn't duplicate it
        unless extracted_types.key?(notif_obj_name.camelize)
          # Replace inline object properties with $refs to extracted types
          properties_with_refs = replace_inline_objects_with_refs(payload_properties, extracted_types)

          nested_notif_def = {
            "type" => "object",
            "description" => "Nested notification data",
            "properties" => properties_with_refs,
            "required" => payload_required_properties,
          }

          # Generate the nested notification object type
          api_name = "notifications/#{notification_name.underscore}"
          nested_type = Type.new(notif_obj_name.camelize, nested_notif_def, api_name, { "definitions" => extracted_types })
          written_files << nested_type.generate
          type_instances << nested_type

          # Add it to extracted types for Payload to reference
          extracted_types[notif_obj_name.camelize] = nested_notif_def
        end
      end

      openapi_spec = {
        "definitions" => extracted_types,
      }

      api_name = "notifications/#{notification_name.underscore}"
      payload_type = Type.new("Payload", payload_type_definition, api_name, openapi_spec)
      written_files << payload_type.generate
      type_instances << payload_type

      { files: written_files, types: type_instances }
    end

    def generate_notification_type!
      # Build spec with Payload reference
      openapi_spec = {
        "definitions" => {
          "Payload" => payload_type_definition,
        },
      }

      api_name = "notifications/#{notification_name.underscore}"
      notification_type = Type.new("Notification", notification_type_definition, api_name, openapi_spec)
      file_path = notification_type.generate

      { file: file_path, type: notification_type }
    end
  end
end
