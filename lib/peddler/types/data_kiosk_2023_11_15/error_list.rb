# frozen_string_literal: true

require "peddler/types/data_kiosk_2023_11_15/error"

module Peddler
  module Types
    module DataKiosk20231115
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] Error response returned when the request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
