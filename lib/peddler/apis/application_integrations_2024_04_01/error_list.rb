# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ApplicationIntegrations20240401
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # Error response returned when the request is unsuccessful.
        attribute(:errors, [Error], null: false)
      end
    end
  end
end
