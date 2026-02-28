# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class DataKiosk20231115
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] Error response returned when the request is unsuccessful.
        attribute(:errors, [Error], null: false)
      end
    end
  end
end
