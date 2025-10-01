# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/replenishment_2022_11_07/error"

module Peddler
  module Types
    module Replenishment20221107
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] A list of error responses returned when a request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
