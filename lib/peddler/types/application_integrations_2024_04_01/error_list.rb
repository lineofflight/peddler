# frozen_string_literal: true

require "peddler/types/application_integrations_2024_04_01/error"

module Peddler
  module Types
    module ApplicationIntegrations20240401
      # A list of error responses returned when a request is unsuccessful.
      ErrorList = Structure.new do
        # @return [Array<Error>] Error response returned when the request is unsuccessful.
        attribute(:errors, [Error])
      end
    end
  end
end
