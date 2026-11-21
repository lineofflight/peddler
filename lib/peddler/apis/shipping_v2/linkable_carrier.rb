# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Info About Linkable Carrier
      LinkableCarrier = Structure.new do
        attribute?(:carrier_id, String, from: "carrierId")

        attribute?(:linkable_account_types, [LinkableAccountType], from: "linkableAccountTypes")
      end
    end
  end
end
