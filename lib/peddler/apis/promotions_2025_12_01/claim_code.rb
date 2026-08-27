# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Claim code configuration for accessing the promotion.
      ClaimCode = Structure.new do
        # @return [String] The type of claim code.
        attribute(:type, String, null: false)

        # @return [String] The claim code (6-12 alphanumeric uppercase). Required when `type` is `GROUP`.
        attribute?(:value, String)
      end
    end
  end
end
