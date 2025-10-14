# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellersV1
      # Information about the seller's primary contact.
      PrimaryContact = Structure.new do
        # @return [Address] The primary contact's residential address.
        attribute(:address, Address)

        # @return [String] The full name of the seller's primary contact.
        attribute(:name, String)

        # @return [String] The non-Latin script version of the primary contact's name, if applicable.
        attribute?(:non_latin_name, String, from: "nonLatinName")
      end
    end
  end
end
