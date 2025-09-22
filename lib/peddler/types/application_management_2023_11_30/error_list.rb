# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/application_management_2023_11_30/error"

module Peddler
  module Types
    module ApplicationManagement20231130
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] array of errors
        attribute(:errors, [Error])
      end
    end
  end
end
