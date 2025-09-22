# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `updateInboundPlanName` request.
      UpdateInboundPlanNameRequest = Structure.new do
        # @return [String] A human-readable name to update the inbound plan name to.
        attribute(:name, String)
      end
    end
  end
end
