# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Carrier Related Info
      Carrier = Structure.new do
        # @return [String]
        attribute(:id, String)

        # @return [String]
        attribute(:name, String)
      end
    end
  end
end
