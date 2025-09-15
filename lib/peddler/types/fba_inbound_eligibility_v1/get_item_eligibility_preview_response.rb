# frozen_string_literal: true

require "peddler/types/fba_inbound_eligibility_v1/item_eligibility_preview"
require "peddler/types/fba_inbound_eligibility_v1/error"

module Peddler
  module Types
    module FBAInboundEligibilityV1
      # The response schema for the getItemEligibilityPreview operation.
      GetItemEligibilityPreviewResponse = Structure.new do
        # @return [ItemEligibilityPreview] The payload for the getItemEligibilityPreview operation.
        attribute(:payload, ItemEligibilityPreview)

        # @return [Array<Error>] An unexpected condition occurred during the GetItemEligibilityPreview operation.
        attribute(:errors, [Error])
      end
    end
  end
end
