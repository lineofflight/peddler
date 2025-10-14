# frozen_string_literal: true

module Peddler
  Money = Data.define(:amount, :currency_code) do
    class << self
      def parse(value)
        return unless value

        currency_code = value["CurrencyCode"] || value["currencyCode"] || value["currency_code"]
        amount_value = value["Amount"] || value["amount"] || value["CurrencyAmount"] ||
          value["currencyAmount"] || value["currency_amount"] || value["value"]
        decimal_amount = BigDecimal(amount_value.to_s)
        # JPY has no subunits
        amount = currency_code == "JPY" ? decimal_amount.to_i.to_s : format("%.2f", decimal_amount)

        new(amount:, currency_code:)
      end
    end

    def to_d # steep:ignore
      BigDecimal(amount) # steep:ignore
    end
  end
end
