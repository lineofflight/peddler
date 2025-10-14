# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
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
