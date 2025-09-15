# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The Response for the UnlinkCarrierAccountResponse operation.
      UnlinkCarrierAccountResponse = Structure.new do
        # @return [:boolean] Is Carrier unlinked from Merchant
        attribute(:unlinked, :boolean, from: "isUnlinked")
      end
    end
  end
end
