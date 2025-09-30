# frozen_string_literal: true

require "peddler/types/uploads_2020_11_01/error"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module Uploads20201101
      # A list of error responses returned when a request is unsuccessful.
      class ErrorList < Array
        class << self
          def parse(array)
            new(array.map { |item| Error.parse(item) })
          end
        end
      end
    end
  end
end
