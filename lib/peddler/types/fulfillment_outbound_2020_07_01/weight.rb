# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The weight.
      Weight = Structure.new do
        # @return [String] The unit of weight.
        attribute(:unit, String)

        # @return [String] The weight value.
        attribute(:value, String)
      end
    end
  end
end
