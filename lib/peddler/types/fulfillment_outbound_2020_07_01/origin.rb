# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The origin for the delivery offer.
      Origin = Structure.new do
        # @return [String] The two digit country code the items should ship from. In ISO 3166-1 alpha-2 format.
        attribute(:country_code, String, from: "countryCode")
      end
    end
  end
end
