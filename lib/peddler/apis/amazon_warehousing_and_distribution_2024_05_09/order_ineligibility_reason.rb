# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AmazonWarehousingAndDistribution20240509
      # Represents one ineligibility reason for the order (there can be multiple reasons).
      OrderIneligibilityReason = Structure.new do
        # @return [String] Code for the order ineligibility.
        attribute(:code, String)

        # @return [String] Description detailing the ineligibility reason of the order.
        attribute(:description, String)
      end
    end
  end
end
