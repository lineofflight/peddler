# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AmazonWarehousingAndDistribution20240509
      # Represents one ineligibility reason for the order (there can be multiple reasons).
      OrderIneligibilityReason = Structure.new do
        # Code for the order ineligibility.
        attribute(:code, String, null: false)

        # Description detailing the ineligibility reason of the order.
        attribute(:description, String, null: false)
      end
    end
  end
end
