# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FBAInventoryV1
      # Describes a granularity at which inventory data can be aggregated. For example, if you use Marketplace
      # granularity, the fulfillable quantity will reflect inventory that could be fulfilled in the given marketplace.
      Granularity = Structure.new do
        # @return [String] The granularity ID for the specified granularity type. When granularityType is Marketplace,
        # specify the marketplaceId.
        attribute?(:granularity_id, String, from: "granularityId")

        # @return [String] The granularity type for the inventory aggregation level.
        attribute?(:granularity_type, String, from: "granularityType")
      end
    end
  end
end
