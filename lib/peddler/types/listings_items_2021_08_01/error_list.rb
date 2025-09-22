# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/listings_items_2021_08_01/error"

module Peddler
  module Types
    module ListingsItems20210801
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
