# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # The preparation details for a product. This contains the prep category, prep owner, and label owner.
      # Prep instructions are generated based on the specified category.
      PrepDetails = Structure.new do
        # @return [String]
        attribute?(:label_owner, String, from: "labelOwner")

        # @return [String] The preparation category for shipping an item to Amazon's fulfillment network.
        attribute?(:prep_category, String, from: "prepCategory")

        # @return [Array<PrepInstruction>] Contains information about the preparation of the inbound products. The
        # system auto-generates this field with the use of the `prepCategory`, and if you attempt to pass a value for
        # this field, the system will ignore it.
        attribute?(:prep_instructions, [PrepInstruction], from: "prepInstructions")

        # @return [String]
        attribute?(:prep_owner, String, from: "prepOwner")
      end
    end
  end
end
