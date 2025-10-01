# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fba_inbound_eligibility_v1/error"
require "peddler/types/fba_inbound_eligibility_v1/item_eligibility_preview"

module Peddler
  module Types
    module FBAInboundEligibilityV1
      # The response schema for the getItemEligibilityPreview operation.
      GetItemEligibilityPreviewResponse = Structure.new do
        # @return [Array<Error>] An unexpected condition occurred during the GetItemEligibilityPreview operation.
        attribute?(:errors, [Error])

        # @return [ItemEligibilityPreview] The payload for the getItemEligibilityPreview operation.
        attribute?(:payload, ItemEligibilityPreview)
      end
    end
  end
end
