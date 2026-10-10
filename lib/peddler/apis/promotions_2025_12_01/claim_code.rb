# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Promotions20251201
      # Claim code configuration for accessing the promotion.
      ClaimCode = Structure.new do
        # The type of claim code.
        attribute(:type, String, null: false)

        # The claim code (6-12 alphanumeric uppercase). Required when `type` is `GROUP`.
        attribute?(:value, String)
      end
    end
  end
end
