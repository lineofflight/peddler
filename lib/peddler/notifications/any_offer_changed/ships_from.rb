# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      ShipsFrom = Structure.new do
        # @return [String]
        attribute(:country, String, null: false, from: "Country")

        # @return [String]
        attribute(:state, String, null: false, from: "State")
      end
    end
  end
end
