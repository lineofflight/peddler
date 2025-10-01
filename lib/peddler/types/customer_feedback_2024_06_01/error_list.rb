# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/customer_feedback_2024_06_01/error"

module Peddler
  module Types
    module CustomerFeedback20240601
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] List of errors.
        attribute(:errors, [Error])
      end
    end
  end
end
