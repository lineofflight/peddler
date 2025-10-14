# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
      # Preparation instructions and who is responsible for the preparation.
      PrepDetails = Structure.new do
        # @return [String]
        attribute(:prep_instruction, String, from: "PrepInstruction")

        # @return [String]
        attribute(:prep_owner, String, from: "PrepOwner")
      end
    end
  end
end
