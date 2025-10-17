# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Feature settings allows you to apply fulfillment features to an order. To block an order from being shipped
      # using Amazon Logistics (AMZL) and an AMZL tracking number, set `featureName` to `BLOCK_AMZL` and
      # `featureFulfillmentPolicy` to `Required`. Blocking AMZL will incur an additional fee surcharge on your MCF
      # orders and increase the risk of some of your orders being unfulfilled or delivered late if there are no
      # alternative carriers available. Using `BLOCK_AMZL` in an order request will take precedence over your Seller
      # Central account setting. To ship in non-Amazon branded packaging (blank boxes), set `featureName` to
      # `BLANK_BOX`. To require a signature from the recipient upon delivery, set `featureName` to
      # `SIGNATURE_CONFIRMATION`. Note that using signature confirmation features will incur additional fees on MCF
      # orders and are currently supported only in the US marketplace. To ensure all items in an order are delivered
      # together, set `featureName` to `DELIVER_TOGETHER`.
      FeatureSettings = Structure.new do
        # @return [String] Specifies the policy to use when fulfilling an order.
        attribute?(:feature_fulfillment_policy, String, from: "featureFulfillmentPolicy")

        # @return [String] The name of the feature. Valid feature names are:
        #
        # - `BLOCK_AMZL`: Blocks orders from being shipped using Amazon Logistics (AMZL).
        # - Note: Using this feature will incur additional fee surcharges on MCF orders and may increase the risk of
        #   unfulfilled or delayed deliveries if alternative carriers are unavailable. Using `BLOCK_AMZL` in an order
        #   request will take precedence over your Seller Central account setting.
        # - `BLANK_BOX`: Ships orders in non-Amazon branded packaging (blank boxes).
        # - `SIGNATURE_CONFIRMATION`: Requires a signature from the recipient upon delivery.
        # - Note: Using signature confirmation features will incur additional fees on MCF orders and are currently
        #   supported only in the US marketplace.
        attribute?(:feature_name, String, from: "featureName")
      end
    end
  end
end
