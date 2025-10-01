# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/reports_2021_06_30/error"

module Peddler
  module Types
    module Reports20210630
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] Error response returned when the request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
