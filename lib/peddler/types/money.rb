# frozen_string_literal: true

module Peddler
  module Types
    Money = Data.define(:amount, :currency_code) do
      NO_SUBUNITS = ["JPY"].freeze
      private_constant :NO_SUBUNITS

      class << self
        def parse(value)
          return unless value

          currency_code = value["CurrencyCode"] || value["currencyCode"] || value["currency_code"]

          # Normalize to a consistent string format since some APIs return numeric and others string. Use standard
          # decimal precision for currencies with subunits, integers for those without.
          decimal_amount = BigDecimal(value["Amount"] || value["amount"] || value["value"])
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
