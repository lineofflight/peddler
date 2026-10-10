# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module AplusContent20201101
      ValidateContentDocumentASINRelationsResponse = Structure.new do
        # A list of error responses returned when a request is unsuccessful.
        attribute(:errors, [Error], null: false)

        attribute?(:warnings, [Error])
      end
    end
  end
end
