# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      IdentifierValue = Structure.new do
        # @return [String]
        attribute(:identifier_value_id, String, from: "IdentifierValueId")

        # @return [String]
        attribute?(:identifier_value_friendly_name, String, from: "IdentifierValueFriendlyName")
      end
    end
  end
end
