# frozen_string_literal: true

require "peddler/types/product_fees_v0/error"

module Peddler
  module Types
    module ProductFeesV0
      # A list of error responses returned when a request is unsuccessful.
      GetMyFeesEstimatesErrorList = Structure.new do
        # @return [Array<Error>] A list of error responses returned when a request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
