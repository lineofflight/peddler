# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] A list of error responses returned when a request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
