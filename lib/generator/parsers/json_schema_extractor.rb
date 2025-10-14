# frozen_string_literal: true

require "json"
require "active_support/inflector"

module Generator
  # Extracts nested type definitions from JSON Schema files
  # Converts inline nested objects into flat definitions that can be processed by Type generator
  class JsonSchemaExtractor
    attr_reader :schema, :notification_name

    def initialize(schema, notification_name)
      @schema = schema
      @notification_name = notification_name
      @extracted_types = {}
    end

    # Extract all nested types from the notification schema or feed schema
    # Returns a hash of type_name => definition (OpenAPI-style)
    def extract_types
      # Start with any existing definitions from the schema
      # These are pre-defined types (especially common in B2B notifications)
      schema["definitions"]&.each do |type_name, type_def|
        # Skip special definitions that aren't actual types (case-insensitive)
        next if ["notificationResponse", "payload"].any? { |skip| skip.casecmp?(type_name) }
        # Skip money-like types - they'll use the shared Money type
        next if money_like_object?(type_def)
        # Skip definitions that are just $ref aliases (no actual object structure)
        # Example: {"$ref": "#/definitions/moneyType", "description": "..."}
        next if type_def["$ref"] && !type_def["type"] && !type_def["properties"]
        # Skip definitions that are just primitive types (string, integer, etc.)
        # Example: {"type": "string", "description": "..."}
        next if ["string", "integer", "number", "boolean"].include?(type_def["type"]) && !type_def["properties"]

        # Convert to PascalCase for consistency
        pascal_name = type_name.camelize
        @extracted_types[pascal_name] = type_def
      end

      # Try to extract from notification schema first (for notification types)
      payload_schema = schema.dig("properties", "payload") || schema.dig("properties", "Payload")

      if payload_schema
        # Find notification-specific object (e.g., "anyOfferChangedNotification" or "AnyOfferChangedNotification")
        notification_schema = find_notification_schema(payload_schema)

        if notification_schema
          # Start recursive extraction from the notification root (will override pre-existing if needed)
          extract_nested_objects(notification_schema, "", notification_name)
        end
      else
        # No payload property - this might be a feed schema with root-level properties
        # Extract types from root properties that are objects
        extract_root_level_types
      end

      # Always run replace_with_refs! to process any extracted types (including definitions-only schemas like B2B)
      replace_with_refs!

      @extracted_types
    end

    private

    # Extract types from root-level properties (for feed schemas)
    # This handles schemas where typed objects are directly in properties, not nested under payload
    def extract_root_level_types
      root_properties = schema["properties"] || {}

      root_properties.each do |prop_name, prop_def|
        # Extract nested structures from object properties
        if prop_def["type"] == "object" && prop_def["properties"]
          # Skip money-like objects
          next if money_like_object?(prop_def)

          # Create a type for this property (e.g., "header" => "Header")
          type_name = prop_name.camelize
          @extracted_types[type_name] = {
            "type" => "object",
            "properties" => prop_def["properties"],
            "required" => prop_def["required"] || [],
            "description" => prop_def["description"],
          }.compact

          # Recursively extract nested objects within this property's properties
          # Pass the type_name as context so nested objects get proper names
          prop_def["properties"].each do |nested_prop_name, nested_prop_def|
            extract_nested_objects(nested_prop_def, nested_prop_name, type_name)
          end
        end

        # Extract nested structures from array items
        next unless prop_def["type"] == "array" && prop_def["items"]

        items = prop_def["items"]

        # If array items are objects with properties, extract them
        next unless items["type"] == "object" && items["properties"]
        # Skip money-like objects
        next if money_like_object?(items)

        # Check if items have additionalProperties: true (flexible structure)
        # These should remain as Hash, not extracted as a type
        next if items["additionalProperties"] == true && items["minProperties"]

        # Create a type for the array items (e.g., "issues" => "Issue")
        type_name = prop_name.singularize.camelize
        @extracted_types[type_name] = {
          "type" => "object",
          "properties" => items["properties"],
          "required" => items["required"] || [],
          "description" => items["description"],
        }.compact

        # Recursively extract nested objects within array item properties
        items["properties"].each do |nested_prop_name, nested_prop_def|
          extract_nested_objects(nested_prop_def, nested_prop_name, type_name)
        end
      end
    end

    def find_notification_schema(payload_schema)
      # Try different naming conventions
      [
        "#{notification_name.camelize(:lower)}Notification", # feedProcessingFinishedNotification
        "#{notification_name.camelize}Notification", # FeedProcessingFinishedNotification
      ].each do |name|
        schema = payload_schema.dig("properties", name)
        return schema if schema
      end

      nil
    end

    # Recursively extract nested object definitions
    # path: current path in the schema (used for naming)
    # parent_name: name of parent type (for context)
    def extract_nested_objects(node, path, parent_name)
      return unless node.is_a?(Hash)

      # Handle objects
      if node["type"] == "object" && node["properties"]
        # Skip money-like objects - they'll be converted to Money type
        return if money_like_object?(node)

        # Generate type for this object (if it's not the root)
        unless path.empty?
          type_name = generate_type_name(path, parent_name)
          # Ensure type name is in PascalCase
          type_name = type_name.camelize unless type_name == type_name.camelize
          @extracted_types[type_name] = {
            "type" => "object",
            "properties" => node["properties"],
            "required" => node["required"] || [],
            "description" => node["description"],
          }
        end

        # Recurse into properties
        node["properties"].each do |prop_name, prop_def|
          new_path = path.empty? ? prop_name : "#{path}_#{prop_name}"
          extract_nested_objects(prop_def, new_path, parent_name)
        end
      end

      # Handle arrays with object items
      if node["type"] == "array" && node["items"]
        items = node["items"]

        # Normalize tuple-style items: [{"$ref": ...}] or [{"type": "object"}]
        items = items.first if items.is_a?(Array) && !items.empty?

        # Handle anyOf in array items
        if items.is_a?(Hash) && items["anyOf"]
          items["anyOf"].each_with_index do |item_schema, _index|
            extract_nested_objects(item_schema, "#{path}_item", parent_name)
          end
        elsif items.is_a?(Hash)
          extract_nested_objects(items, "#{path}_item", parent_name)
        end
      end

      # Handle anyOf compositions
      node["anyOf"]&.each_with_index do |variant_schema, _index|
        extract_nested_objects(variant_schema, path, parent_name)
      end

      # Handle allOf compositions
      node["allOf"]&.each do |variant_schema|
        extract_nested_objects(variant_schema, path, parent_name)
      end
    end

    # Replace inline nested objects with $ref pointers to extracted types
    def replace_with_refs!
      @extracted_types.each do |_type_name, type_def|
        next unless type_def["properties"]

        type_def["properties"].each do |prop_name, prop_def|
          # Convert $refs to money-like types to Money references
          if prop_def["$ref"]
            ref_name = prop_def["$ref"].split("/").last
            # Resolve the $ref chain to find the actual definition
            resolved_def = resolve_ref_chain(ref_name)
            if resolved_def && money_like_object?(resolved_def)
              type_def["properties"][prop_name] = {
                "$ref" => "#/definitions/Money",
                "description" => prop_def["description"],
              }.compact
              next
            end
          end

          # Convert money-like objects to Money type references
          if money_like_object?(prop_def)
            type_def["properties"][prop_name] = {
              "$ref" => "#/definitions/Money",
              "description" => prop_def["description"],
            }.compact
            next
          end

          # Check if this property has a corresponding extracted type
          # Property names are camelCase/PascalCase in JSON, but type names are PascalCase
          type_name_to_match = prop_name.camelize
          matching_type_name = @extracted_types.keys.find { |t| t == type_name_to_match }

          if matching_type_name && prop_def["type"] == "object"
            # Replace with $ref
            type_def["properties"][prop_name] = {
              "$ref" => "#/definitions/#{matching_type_name}",
              "description" => prop_def["description"],
            }.compact
          elsif prop_def["type"] == "array" && prop_def["items"]
            items = prop_def["items"]

            # Handle tuple-style items: [{"$ref": "#/definitions/foo"}]
            if items.is_a?(Array) && items.length == 1 && items[0]["$ref"]
              # Extract type name from $ref
              ref_path = items[0]["$ref"]
              ref_type_name = ref_path.split("/").last.camelize

              # Check if we have this type extracted
              if @extracted_types.key?(ref_type_name)
                type_def["properties"][prop_name]["items"] = {
                  "$ref" => "#/definitions/#{ref_type_name}",
                }
              end
              next
            end

            # Handle inline object items
            if items.is_a?(Hash) && items["type"] == "object"
              # Convert array items that are money-like to Money references
              if money_like_object?(items)
                type_def["properties"][prop_name]["items"] = {
                  "$ref" => "#/definitions/Money",
                }
                next
              end

              # Check if array items match a type
              item_type_name = prop_name.singularize.camelize
              matching_item_type = @extracted_types.keys.find { |t| t == item_type_name }

              if matching_item_type
                type_def["properties"][prop_name]["items"] = {
                  "$ref" => "#/definitions/#{matching_item_type}",
                }
              end
            end
          end
        end
      end
    end

    # Detect if an object looks like a Money type
    # Money objects have: amount/Amount (number) + currencyCode/CurrencyCode (string)
    def money_like_object?(node)
      return false unless node["type"] == "object"
      return false unless node["properties"]

      props = node["properties"]

      # Check for both camelCase and PascalCase variants
      has_amount = props.key?("Amount") || props.key?("amount") || props.key?("currencyAmount")
      has_currency = props.key?("CurrencyCode") || props.key?("currencyCode")

      return false unless has_amount && has_currency

      # Verify types
      amount_prop = props["Amount"] || props["amount"] || props["currencyAmount"]
      currency_prop = props["CurrencyCode"] || props["currencyCode"]

      amount_prop&.dig("type") == "number" && currency_prop&.dig("type") == "string"
    end

    # Generate a type name from a JSON path
    # Use the LAST segment as the type name (like Amazon does in their OpenAPI specs)
    # Examples:
    #   "offers_item" => "Offer" (singularized array item)
    #   "offer_change_trigger" => "OfferChangeTrigger" (direct property name)
    #   "offers_item_shipping_time" => "ShippingTime" (leaf property name)
    #   "summary_lowest_prices_item" => "LowestPrice" (singularized)
    def generate_type_name(path, parent_name)
      segments = path.split("_")

      # Find the last occurrence of "item"
      last_item_index = segments.rindex("item")

      if last_item_index
        if last_item_index < segments.length - 1
          # There are segments after "item" - these are properties of the array item
          # Use only these segments (leaf property name)
          # Property names from JSON schema are already in PascalCase, just join them
          # e.g., "Offers_item_ShippingTime" => "ShippingTime"
          leaf_segments = segments[(last_item_index + 1)..-1]
          return leaf_segments.join if leaf_segments
        elsif last_item_index > 0
          # Path ends with "item" - this represents the array item type itself
          # Take just the segment immediately before "item" and singularize
          # Property names are already in PascalCase
          # e.g., "Offers_item" => "Offers" => "Offer"
          # e.g., "Summary_BuyBoxPrices_item" => "BuyBoxPrices" => "BuyBoxPrice"
          array_property = segments[last_item_index - 1]
          return array_property.singularize
        end
      else
        # No array involved - use only the last segment (property name itself)
        # Property names are already in PascalCase
        # e.g., "Summary_ListPrice" => "ListPrice"
        # e.g., "OfferChangeTrigger" => "OfferChangeTrigger"
        return segments.last
      end

      # Fallback
      parent_name.camelize
    end

    # Resolve a $ref chain to find the actual definition
    # Follows $ref pointers until it finds a definition with actual content
    # Returns the resolved definition or nil if not found
    def resolve_ref_chain(ref_name, visited = [])
      # Prevent infinite loops
      return if visited.include?(ref_name)

      ref_def = schema.dig("definitions", ref_name)
      return unless ref_def

      # If this definition is just a $ref to another definition, follow it
      if ref_def["$ref"] && !ref_def["type"] && !ref_def["properties"]
        next_ref = ref_def["$ref"].split("/").last
        resolve_ref_chain(next_ref, visited + [ref_name])
      else
        # We found the actual definition
        ref_def
      end
    end
  end
end
