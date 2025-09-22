# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vehicles_2024_11_01/error"

module Peddler
  module Types
    module Vehicles20241101
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] array of errors
        attribute(:errors, [Error])
      end
    end
  end
end
