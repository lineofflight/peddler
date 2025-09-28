# frozen_string_literal: true

require "peddler/types/catalog_items_v0/error"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module CatalogItemsV0
      # A list of error responses returned when a request is unsuccessful.
      class ErrorList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| Error.parse(item) }) : new
          end
        end
      end
    end
  end
end
