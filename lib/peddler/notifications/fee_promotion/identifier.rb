# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      Identifier = Structure.new do
        # @return [String]
        attribute(:identifier_type, String, from: "IdentifierType")

        # @return [Array]
        attribute(:identifier_values, Array, from: "IdentifierValues")
      end
    end
  end
end
