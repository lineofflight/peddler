# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Service Selection Criteria.
      ServiceSelection = Structure.new do
        # @return [Array]
        attribute(:service_id, Array, from: "serviceId")
      end
    end
  end
end
