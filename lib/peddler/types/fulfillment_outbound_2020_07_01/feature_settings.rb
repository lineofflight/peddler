# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Feature settings allows you to apply fulfillment features to an order. To block an order from being shipped
      # using Amazon Logistics (AMZL) and an AMZL tracking number, set `featureName` to `BLOCK_AMZL` and
      # `featureFulfillmentPolicy` to `Required`. Blocking AMZL will incur an additional fee surcharge on your MCF
      # orders and increase the risk of some of your orders being unfulfilled or delivered late if there are no
      # alternative carriers available. Using `BLOCK_AMZL` in an order request will take precedence over your Seller
      # Central account setting. To ship in non-Amazon branded packaging (blank boxes), set `featureName` to
      # `BLANK_BOX`.
      FeatureSettings = Structure.new do
        # @return [String] The name of the feature.
        attribute?(:feature_name, String, from: "featureName")

        # @return [String] Specifies the policy to use when fulfilling an order.
        attribute?(:feature_fulfillment_policy, String, from: "featureFulfillmentPolicy")
      end
    end
  end
end
