# frozen_string_literal: true

require "peddler/types/catalog_items_2022_04_01/error"

module Peddler
  module Types
    module CatalogItems20220401
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>]
        attribute(:errors, [Error])
      end
    end
  end
end
