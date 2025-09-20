# frozen_string_literal: true

require "peddler/types/listings_restrictions_2021_08_01/error"

module Peddler
  module Types
    module ListingsRestrictions20210801
      # A list of error responses returned when a request is unsuccessful.
      class ErrorList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| Error.parse(item) })
          end
        end
      end
    end
  end
end
