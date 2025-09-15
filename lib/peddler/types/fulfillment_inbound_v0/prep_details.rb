# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInboundV0
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
