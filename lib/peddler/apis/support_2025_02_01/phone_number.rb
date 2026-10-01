# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Support20250201
      # The selling partner's phone number.
      PhoneNumber = Structure.new do
        # @return [String] The ISO 3166-1 two-digit country code for the calling country.
        attribute(:country_code, String, null: false, from: "countryCode")

        # @return [String] The phone number to call.
        attribute(:number, String, null: false)

        # @return [String] The extension to use for the call, if applicable.
        attribute?(:extension, String)
      end
    end
  end
end
