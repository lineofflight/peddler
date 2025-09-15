# frozen_string_literal: true

require "money"

Money.rounding_mode = BigDecimal::ROUND_HALF_UP

module Peddler
  # Coerces Amazon SP-API monetary values to Money objects
  class Money
    class << self
      def parse(value)
        return unless value

        amount = value["Amount"] || value["amount"] || value["value"]
        currency = value["CurrencyCode"] || value["currencyCode"]

        return unless amount && currency

        # The Money gem expects amounts in the smallest unit (e.g., cents for USD)
        #
        # We need to check the currency's subunit_to_unit to handle this correctly:
        # - For currencies like USD: multiply by 100
        # - For JPY: use as-is
        subunit_to_unit = ::Money::Currency.new(currency).subunit_to_unit
        if subunit_to_unit == 1
          ::Money.new(amount.to_i, currency)
        else
          fractional = (amount.to_f * subunit_to_unit).round
          ::Money.new(fractional, currency)
        end
      end
    end
  end
end
