# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/feature"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The payload for the `getFeatures` operation.
      GetFeaturesResult = Structure.new do
        # @return [Array<Feature>]
        attribute(:features, [Feature])
      end
    end
  end
end
