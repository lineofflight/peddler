# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/shipping_v2/linkable_account_type"

module Peddler
  module Types
    module ShippingV2
      # Info About Linkable Carrier
      LinkableCarrier = Structure.new do
        # @return [String]
        attribute?(:carrier_id, String, from: "carrierId")

        # @return [Array<LinkableAccountType>]
        attribute?(:linkable_account_types, [LinkableAccountType], from: "linkableAccountTypes")
      end
    end
  end
end
