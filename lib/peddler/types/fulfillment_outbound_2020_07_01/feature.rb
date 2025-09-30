# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # A Multi-Channel Fulfillment feature.
      Feature = Structure.new do
        # @return [String] The feature name.
        attribute(:feature_name, String, from: "featureName")

        # @return [String] The feature description.
        attribute(:feature_description, String, from: "featureDescription")

        # @return [:boolean] When true, indicates that the seller is eligible to use the feature.
        attribute?(:seller_eligible, :boolean, from: "sellerEligible")
      end
    end
  end
end
