require 'peddler/parsers/model'
require 'mws/products/parsers/shipping_time'

module MWS
  module Products
    module Parsers
      class Qualifiers < ::Peddler::Parsers::Model
        value :item_condition do
          text_at_xpath('ItemCondition')
        end

        value :item_subcondition do
          text_at_xpath('ItemSubcondition')
        end

        value :fulfillment_channel do
          text_at_xpath('FulfillmentChannel')
        end

        value :shipping_time do
          node = at_xpath('ShippingTime')
          ShippingTime.new(node)
        end

        value :seller_positive_feedback_rating do
          text_at_xpath('SellerPositiveFeedbackRating')
        end
      end
    end
  end
end
