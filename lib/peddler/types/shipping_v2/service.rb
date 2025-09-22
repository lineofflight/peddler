# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Service Related Info
      Service = Structure.new do
        # @return [String]
        attribute(:id, String)

        # @return [String]
        attribute(:name, String)
      end
    end
  end
end
