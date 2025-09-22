# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/incentive"
require "peddler/types/fulfillment_inbound_2024_03_20/packing_configuration"
require "peddler/types/fulfillment_inbound_2024_03_20/shipping_configuration"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # A packing option contains a set of pack groups plus additional information about the packing option, such as any
      # discounts or fees if it's selected.
      PackingOption = Structure.new do
        # @return [Array<Incentive>] Discount for the offered option.
        attribute(:discounts, [Incentive])

        # @return [String] The time at which this packing option is no longer valid. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute(:expiration, String)

        # @return [Array<Incentive>] Fee for the offered option.
        attribute(:fees, [Incentive])

        # @return [Array<String>] Packing group IDs.
        attribute(:packing_groups, [String], from: "packingGroups")

        # @return [String] Identifier of a packing option.
        attribute(:packing_option_id, String, from: "packingOptionId")

        # @return [String] The status of the packing option. Possible values: `OFFERED`, `ACCEPTED`, `EXPIRED`.
        attribute(:status, String)

        # @return [Array<PackingConfiguration>] A list of possible configurations for this option.
        attribute(:supported_configurations, [PackingConfiguration], from: "supportedConfigurations")

        # @return [Array<ShippingConfiguration>] **This field is deprecated**. Use the `shippingRequirements` property
        # under `supportedConfigurations` instead. List of supported shipping modes.
        attribute(:supported_shipping_configurations, [ShippingConfiguration], from: "supportedShippingConfigurations")
      end
    end
  end
end
