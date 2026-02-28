# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # A list of error responses that are returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] List of errors.
        attribute(:errors, [Error], null: false)
      end
    end
  end
end
