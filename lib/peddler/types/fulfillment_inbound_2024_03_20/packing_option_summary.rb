# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Summary information about a packing option.
      PackingOptionSummary = Structure.new do
        # @return [String] Identifier of a packing option.
        attribute(:packing_option_id, String, from: "packingOptionId")

        # @return [String] The status of a packing option. Possible values: 'OFFERED', 'ACCEPTED', 'EXPIRED'.
        attribute(:status, String)
      end
    end
  end
end
