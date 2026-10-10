# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FBAInboundEligibilityV1
      # The response schema for the getItemEligibilityPreview operation.
      GetItemEligibilityPreviewResponse = Structure.new do
        # An unexpected condition occurred during the GetItemEligibilityPreview operation.
        attribute?(:errors, [Error])

        # The payload for the getItemEligibilityPreview operation.
        attribute?(:payload, ItemEligibilityPreview)
      end
    end
  end
end
