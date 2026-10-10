# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The weight of a package.
      Weight = Structure.new do
        attribute(:unit, String, null: false)

        # Value of a weight.
        attribute(:value, Float, null: false)
      end
    end
  end
end
