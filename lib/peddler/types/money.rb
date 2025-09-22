# frozen_string_literal: true

module Peddler
  module Types
    Money = Data.define(:amount, :currency_code) do
      class << self
        NO_SUBUNITS = ["JPY"].freeze
        private_constant :NO_SUBUNITS

        def parse(value)
          return unless value

          currency_code = value["CurrencyCode"] || value["currencyCode"] || value["currency_code"]

          # Normalize to a consistent string format since some APIs return numeric and others string. Use standard
          # decimal precision for currencies with subunits, integers for those without.
          # Handle different field names for amount: Amount, amount, CurrencyAmount, currencyAmount, value
          amount_value = value["Amount"] || value["amount"] || value["CurrencyAmount"] ||
            value["currencyAmount"] || value["currency_amount"] || value["value"]
          # Convert to string to ensure BigDecimal compatibility across Ruby versions
          decimal_amount = BigDecimal(amount_value.to_s)
          amount = NO_SUBUNITS.include?(currency_code) ? decimal_amount.to_i.to_s : format("%.2f", decimal_amount)

          new(amount:, currency_code:)
        end
      end

      def to_d
        BigDecimal(amount)
      end
    end
  end
end
