# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Information about an asset linked to an associated item, such as vehicle information for Ship-to-Store orders.
      LinkedAsset = Structure.new do
        # @return [Hash] Additional attributes of the linked asset, such as vehicle make, model, year, and engine
        #   details.
        attribute?(:additional_attributes, Hash, from: "additionalAttributes")

        # @return [String] The name of the linked asset. For example: `2024 Polaris Slingshot SLR AutoDrive`.
        attribute?(:asset_name, String, from: "assetName")

        # @return [String] The type of the linked asset. For example: `VEHICLE`.
        attribute?(:asset_type, String, from: "assetType")
      end
    end
  end
end
