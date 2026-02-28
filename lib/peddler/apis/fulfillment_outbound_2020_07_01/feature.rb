# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # A Multi-Channel Fulfillment feature.
      Feature = Structure.new do
        # @return [String] The feature description.
        attribute(:feature_description, String, null: false, from: "featureDescription")

        # @return [String] The feature name.
        attribute(:feature_name, String, null: false, from: "featureName")

        # @return [:boolean] When true, indicates that the seller is eligible to use the feature.
        attribute?(:seller_eligible, :boolean, from: "sellerEligible")
      end
    end
  end
end
