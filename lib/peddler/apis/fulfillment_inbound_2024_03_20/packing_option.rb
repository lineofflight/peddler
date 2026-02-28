# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # A packing option contains a set of pack groups plus additional information about the packing option, such as any
      # discounts or fees if it's selected.
      PackingOption = Structure.new do
        # @return [Array<Incentive>] Discount for the offered option.
        attribute(:discounts, [Incentive], null: false)

        # @return [Array<Incentive>] Fee for the offered option.
        attribute(:fees, [Incentive], null: false)

        # @return [Array<String>] Packing group IDs.
        attribute(:packing_groups, [String], null: false, from: "packingGroups")

        # @return [String] Identifier of a packing option.
        attribute(:packing_option_id, String, null: false, from: "packingOptionId")

        # @return [String] The status of the packing option. Possible values: `OFFERED`, `ACCEPTED`, `EXPIRED`.
        attribute(:status, String, null: false)

        # @return [Array<PackingConfiguration>] A list of possible configurations for this option.
        attribute(:supported_configurations, [PackingConfiguration], null: false, from: "supportedConfigurations")

        # @return [Array<ShippingConfiguration>] **This field is deprecated**. Use the `shippingRequirements` property
        #   under `supportedConfigurations` instead. List of supported shipping modes.
        attribute(:supported_shipping_configurations, [ShippingConfiguration], null: false, from: "supportedShippingConfigurations")

        # @return [Time] The time at which this packing option is no longer valid. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        #   `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute?(:expiration, Time)
      end
    end
  end
end
