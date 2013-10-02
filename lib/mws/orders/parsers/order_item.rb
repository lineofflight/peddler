require 'mws/orders/parsers/invoice_data'
require 'peddler/parsers/model'

module MWS
  module Orders
    module Parsers
      class OrderItem < ::Peddler::Parsers::Model
        value :asin do
          text_at_xpath('ASIN')
        end

        value :seller_sku do
          text_at_xpath('SellerSKU')
        end

        value :order_item_id do
          text_at_xpath('OrderItemId')
        end

        value :title do
          text_at_xpath('Title')
        end

        value :quantity_ordered do
          integer_at_xpath('QuantityOrdered')
        end

        value :quantity_shipped do
          integer_at_xpath('QuantityShipped')
        end

        value :gift_message_text do
          text_at_xpath('GiftMessageText')
        end

        value :gift_wrap_level do
          text_at_xpath('GiftWrapLevel')
        end

        value :item_price do
          money_at_xpath('ItemPrice')
        end

        value :shipping_price do
          money_at_xpath('ShippingPrice')
        end

        value :gift_wrap_price do
          money_at_xpath('GiftWrapPrice')
        end

        value :item_tax do
          money_at_xpath('ItemTax')
        end

        value :shipping_tax do
          money_at_xpath('ShippingTax')
        end

        value :gift_wrap_tax do
          money_at_xpath('GiftWrapPrice')
        end

        value :shipping_discount do
          money_at_xpath('ShippingDiscount')
        end

        value :promotion_discount do
          money_at_xpath('PromotionDiscount')
        end

        value :promotion_ids do
          xpath('PromotionId').map(&:text)
        end

        value :cod_fee do
          money_at_xpath('CODFee')
        end

        value :cod_fee_discount do
          money_at_xpath('CODFeeDiscount')
        end

        value :invoice_data do
          xpath('InvoiceData').map { |node| InvoiceData.new(node) }
        end

        value :condition_id do
          text_at_xpath('ConditionId')
        end

        value :condition_subtype_id do
          text_at_xpath('ConditionSubtypeId')
        end

        value :condition_note do
          text_at_xpath('ConditionNote')
        end

        value :scheduled_delivery_ends_at do
          time_at_xpath('ScheduledDeliveryEndDate')
        end

        value :scheduled_delivery_starts_at do
          time_at_xpath('ScheduledDeliveryStartDate')
        end
      end
    end
  end
end
