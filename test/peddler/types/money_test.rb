# frozen_string_literal: true

require "helper"
require "peddler/types/money"

module Peddler
  module Types
    class MoneyTest < Minitest::Test
      def test_parse_with_string_amount
        amount_hash = { "Amount" => "99.99", "CurrencyCode" => "USD" }
        money = Money.parse(amount_hash)

        assert_equal("99.99", money.amount)
        assert_equal("USD", money.currency_code)
      end

      def test_parse_with_numeric_amount
        amount_hash = { "Amount" => 10.0, "CurrencyCode" => "USD" }
        money = Money.parse(amount_hash)

        assert_equal("10.00", money.amount)
        assert_equal("USD", money.currency_code)
      end

      def test_parse_with_amount_with_no_subunits
        integer_hash = { "Amount" => 1500, "CurrencyCode" => "JPY" }
        money = Money.parse(integer_hash)

        assert_equal("1500", money.amount)
        assert_equal("JPY", money.currency_code)
      end

      def test_parse_with_nil
        assert_nil(Money.parse(nil))
      end

      def test_to_d
        money = Money.parse({ "amount" => "29.99", "currencyCode" => "USD" })

        assert_equal(BigDecimal("29.99"), money.to_d)
      end

      def test_equality
        money1 = Money.parse({ "amount" => "29.99", "currencyCode" => "USD" })
        money2 = Money.parse({ "amount" => "29.99", "currencyCode" => "USD" })
        money3 = Money.parse({ "amount" => "29.99", "currencyCode" => "EUR" })
        money4 = Money.parse({ "amount" => "30.00", "currencyCode" => "USD" })

        assert_equal(money1, money2)
        refute_equal(money1, money3) # Different currency
        refute_equal(money1, money4) # Different amount
      end
    end
  end
end
