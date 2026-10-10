# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      Identifier = Structure.new do
        attribute(:identifier_type, String, null: false, from: "IdentifierType")

        attribute(:identifier_values, Array, null: false, from: "IdentifierValues")
      end
    end
  end
end
