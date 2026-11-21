# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Promotions20251201
      # The response schema for `getSelection`. The `selectionDetails` field is always present when `type` is `ITEMS`.
      GetSelectionResponse = Structure.new do
        attribute(:selection, Selection, null: false)
      end
    end
  end
end
