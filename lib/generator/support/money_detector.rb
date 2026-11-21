# frozen_string_literal: true

module Generator
  # Detects Money-like objects in JSON Schema definitions and known Money type names
  module MoneyDetector
    # Known Money type names used in SP-API specifications
    MONEY_TYPES = ["Money", "MoneyType", "Currency", "CurrencyAmount"].freeze

    class << self
      # Check if a type name is a known Money type
      def money_type?(name)
        MONEY_TYPES.include?(name)
      end

      # Detect if an object definition looks like a Money type
      # Money objects have: amount/Amount/currencyAmount (number) + currencyCode/CurrencyCode (string)
      # The definition is the JSON Schema object definition.
      def money_like?(definition)
        return false unless definition.is_a?(Hash) && definition["type"] == "object"
        return false unless definition["properties"]

        props = definition["properties"]

        # Check for both camelCase and PascalCase variants
        has_amount = props.key?("Amount") || props.key?("amount") || props.key?("currencyAmount")
        has_currency = props.key?("CurrencyCode") || props.key?("currencyCode")

        return false unless has_amount && has_currency

        # Verify types
        amount_prop = props["Amount"] || props["amount"] || props["currencyAmount"]
        currency_prop = props["CurrencyCode"] || props["currencyCode"]

        amount_prop&.dig("type") == "number" && currency_prop&.dig("type") == "string"
      end
    end
  end
end
