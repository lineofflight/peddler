require 'mws/orders/parsers/shipping_address'
require 'mws/orders/parsers/payment_execution_detail'
require 'peddler/parsers/model'

module MWS
  module Orders
    module Parsers
      class Order < ::Peddler::Parsers::Model
        value :amazon_order_id do
          text_at_xpath('AmazonOrderId')
        end

        value :seller_order_id do
          text_at_xpath('SellerOrderId')
        end

        value :purchased_at do
          time_at_xpath('PurchaseDate')
        end

        value :last_updated_at do
          time_at_xpath('LastUpdateDate')
        end

        value :status do
          text_at_xpath('OrderStatus')
        end

        value :fulfillment_channel do
          text_at_xpath('FulfillmentChannel')
        end

        value :sales_channel do
          text_at_xpath('SalesChannel')
        end

        value :order_channel do
          text_at_xpath('OrderChannel')
        end

        value :ship_service_level do
          text_at_xpath('ShipServiceLevel')
        end

        value :shipping_address do
          node = at_xpath('ShippingAddress')
          ShippingAddress.new(node) if node
        end

        value :total do
          money_at_xpath('OrderTotal')
        end

        value :number_of_items_shipped do
          integer_at_xpath('NumberOfItemsShipped')
        end

        value :number_of_items_unshipped do
          integer_at_xpath('NumberOfItemsUnshipped')
        end

        value :payment_execution_detail do
          node = at_xpath('PaymentExecutionDetail')
          PaymentExecutionDetail.new(node) if node
        end

        value :payment_method do
          text_at_xpath('PaymentMethod')
        end

        value :marketplace_id do
          text_at_xpath('MarketplaceId')
        end

        value :buyer_name do
          text_at_xpath('BuyerName')
        end

        value :buyer_email do
          text_at_xpath('BuyerEmail')
        end

        value :shipment_service_level_category do
          text_at_xpath('ShipmentServiceLevelCategory')
        end

        value :cba_displayable_shipping_label do
          text_at_xpath('CbaDisplayableShippingLabel')
        end

        value :shipped_by_amazon_tfm do
          text_at_xpath('ShippedByAmazonTFM')
        end

        value :tfm_shipment_status do
          text_at_xpath('TFMShipmentStatus')
        end

        value :type do
          text_at_xpath('OrderType')
        end

        value :earliest_shipped_at do
          time_at_xpath('EarliestShipDate')
        end

        value :latest_shipped_at do
          time_at_xpath('LatestShipDate')
        end
      end
    end
  end
end
