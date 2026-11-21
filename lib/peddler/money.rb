# frozen_string_literal: true

module Peddler
  # @rbs skip
  Money = Data.define(:amount, :currency_code) # :nodoc:

  # An amount of money in a typed model: its `amount`, a String that holds a decimal, and its `currency_code`
  class Money
    ##
    # :attr_reader: amount
    # The amount as a String that holds a decimal, such as "10.00"

    ##
    # :attr_reader: currency_code
    # The ISO 4217 code of the currency, such as "USD"

    #: (untyped value) -> Money?
    def self.parse(value)
      return unless value

      currency_code = value["CurrencyCode"] || value["currencyCode"] || value["currency_code"]
      amount_value = value["Amount"] || value["amount"] || value["CurrencyAmount"] ||
        value["currencyAmount"] || value["currency_amount"] || value["value"]
      decimal_amount = BigDecimal(amount_value.to_s)
      # JPY has no subunits
      amount = currency_code == "JPY" ? decimal_amount.to_i.to_s : format("%.2f", decimal_amount)

      new(amount:, currency_code:)
    end

    #: () -> BigDecimal
    def to_d
      BigDecimal(amount)
    end
  end
end
