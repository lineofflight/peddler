# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # The response schema for `getSelection`. The `selectionDetails` field is always present when `type` is `ITEMS`.
      GetSelectionResponse = Structure.new do
        # @return [Selection]
        attribute(:selection, Selection, null: false)
      end
    end
  end
end
