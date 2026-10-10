# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      ShipsFrom = Structure.new do
        attribute?(:country, String, from: "Country")

        attribute?(:state, String, from: "State")
      end
    end
  end
end
