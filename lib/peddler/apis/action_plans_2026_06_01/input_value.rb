# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ActionPlans20260601
      # An input or output value carried as an array of strings.
      InputValue = Structure.new do
        # The value, as an array of strings.
        attribute(:value, [String], null: false)
      end
    end
  end
end
