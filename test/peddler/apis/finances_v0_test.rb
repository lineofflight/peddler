# frozen_string_literal: true

require "helper"
require "structure"

module Peddler
  module APIs
    class FinancesV0Test < Minitest::Test
      def test_charge_component_money_field
        data = {
          "ChargeType" => "Principal",
          "ChargeAmount" => {
            "CurrencyCode" => "EUR",
            "CurrencyAmount" => "49.99",
          },
        }
        charge = FinancesV0::ChargeComponent.parse(data)

        assert_instance_of(Peddler::Money, charge.charge_amount)
        assert_equal("49.99", charge.charge_amount.amount)
        assert_equal("EUR", charge.charge_amount.currency_code)
      end

      def test_financial_events_array_structures
        data = {
          "ShipmentEventList" => [
            {
              "AmazonOrderId" => "123",
              "ShipmentItemList" => [],
            },
          ],
          "RefundEventList" => [],
          "GuaranteeClaimEventList" => [],
          "ChargebackEventList" => [],
        }
        events = FinancesV0::FinancialEvents.parse(data)

        assert_equal(1, events.shipment_event_list.length)
        assert_instance_of(FinancesV0::ShipmentEvent, events.shipment_event_list.first)
        assert_empty(events.refund_event_list)
      end

      def test_fee_component_money_field
        data = {
          "FeeType" => "FBAPerUnitFulfillmentFee",
          "FeeAmount" => {
            "CurrencyCode" => "USD",
            "CurrencyAmount" => "2.50",
          },
        }
        fee = FinancesV0::FeeComponent.parse(data)

        assert_instance_of(Peddler::Money, fee.fee_amount)
        assert_equal("2.50", fee.fee_amount.amount)
        assert_equal("USD", fee.fee_amount.currency_code)
      end

      def test_list_financial_events_response_nesting
        data = {
          "payload" => {
            "FinancialEvents" => {
              "ShipmentEventList" => [],
            },
            "NextToken" => "next123",
          },
        }
        response = FinancesV0::ListFinancialEventsResponse.parse(data)

        assert_instance_of(FinancesV0::ListFinancialEventsPayload, response.payload)
        assert_instance_of(FinancesV0::FinancialEvents, response.payload.financial_events)
        assert_equal("next123", response.payload.next_token)
      end

      def test_promotion_money_field
        data = {
          "PromotionType" => "Coupon",
          "PromotionId" => "PROMO123",
          "PromotionAmount" => {
            "CurrencyCode" => "GBP",
            "CurrencyAmount" => "5.00",
          },
        }
        promotion = FinancesV0::Promotion.parse(data)

        assert_instance_of(Peddler::Money, promotion.promotion_amount)
        assert_equal("5.00", promotion.promotion_amount.amount)
        assert_equal("GBP", promotion.promotion_amount.currency_code)
      end

      def test_shipment_item_with_nested_arrays
        data = {
          "SellerSKU" => "SKU123",
          "ItemChargeList" => [
            {
              "ChargeType" => "Principal",
              "ChargeAmount" => {
                "CurrencyCode" => "USD",
                "CurrencyAmount" => "10.00",
              },
            },
          ],
        }
        item = FinancesV0::ShipmentItem.parse(data)

        assert_equal(1, item.item_charge_list.length)
        assert_instance_of(FinancesV0::ChargeComponent, item.item_charge_list.first)
        assert_instance_of(Peddler::Money, item.item_charge_list.first.charge_amount)
      end
    end
  end
end
