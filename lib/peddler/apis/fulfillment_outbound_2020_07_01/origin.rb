# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The origin for the delivery offer.
      Origin = Structure.new do
        # @return [String] The two digit country code the items should ship from. In ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, null: false, from: "countryCode")
      end
    end
  end
end
