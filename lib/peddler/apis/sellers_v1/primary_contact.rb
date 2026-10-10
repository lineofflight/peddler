# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SellersV1
      # Information about the seller's primary contact.
      PrimaryContact = Structure.new do
        # The primary contact's residential address.
        attribute(:address, Address, null: false)

        # The full name of the seller's primary contact.
        attribute(:name, String, null: false)

        # The non-Latin script version of the primary contact's name, if applicable.
        attribute?(:non_latin_name, String, from: "nonLatinName")
      end
    end
  end
end
