# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # A packing option contains a set of pack groups plus additional information about the packing option, such as any
      # discounts or fees if it's selected.
      PackingOption = Structure.new do
        # Discount for the offered option.
        attribute(:discounts, [Incentive], null: false)

        # Fee for the offered option.
        attribute(:fees, [Incentive], null: false)

        # Packing group IDs.
        attribute(:packing_groups, [String], null: false, from: "packingGroups")

        # Identifier of a packing option.
        attribute(:packing_option_id, String, null: false, from: "packingOptionId")

        # The status of the packing option. Possible values: `OFFERED`, `ACCEPTED`, `EXPIRED`.
        attribute(:status, String, null: false)

        # A list of possible configurations for this option.
        attribute(:supported_configurations, [PackingConfiguration], null: false, from: "supportedConfigurations")

        # **This field is deprecated**. Use the `shippingRequirements` property under `supportedConfigurations` instead.
        # List of supported shipping modes.
        attribute(:supported_shipping_configurations, [ShippingConfiguration], null: false, from: "supportedShippingConfigurations")

        # The time at which this packing option is no longer valid. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern
        # `yyyy-MM-ddTHH:mm:ss.sssZ`.
        attribute?(:expiration, Time)
      end
    end
  end
end
