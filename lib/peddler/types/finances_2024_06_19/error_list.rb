# frozen_string_literal: true

require "peddler/types/finances_2024_06_19/error"

module Peddler
  module Types
    module Finances20240619
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] Error response returned when the request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
