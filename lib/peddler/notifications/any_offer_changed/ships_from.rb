# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      ShipsFrom = Structure.new do
        attribute(:country, String, null: false, from: "Country")

        attribute(:state, String, null: false, from: "State")
      end
    end
  end
end
