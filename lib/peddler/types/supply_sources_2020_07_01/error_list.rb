# frozen_string_literal: true

require "peddler/types/supply_sources_2020_07_01/error"

module Peddler
  module Types
    module SupplySources20200701
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] A list of error responses returned when a request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
