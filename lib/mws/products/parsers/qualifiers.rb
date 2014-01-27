require 'peddler/parsers/model'

module MWS
  module Products
    module Parsers
      class Qualifiers < ::Peddler::Parsers::Model

        [ :item_condition, :item_subcondition,
          :fulfillment_channel, :seller_positive_feedback_rating].each do |method|
          define_method method do
            text_at_xpath(method.to_s.split('_').map(&:capitalize).join)
          end
        end

      end
    end
  end
end
