# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_type_definitions_2020_09_01/error"

module Peddler
  module Types
    module ProductTypeDefinitions20200901
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
