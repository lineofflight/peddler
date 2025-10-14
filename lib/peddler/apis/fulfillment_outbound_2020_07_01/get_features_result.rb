# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The payload for the `getFeatures` operation.
      GetFeaturesResult = Structure.new do
        # @return [Array<Feature>]
        attribute(:features, [Feature])
      end
    end
  end
end
