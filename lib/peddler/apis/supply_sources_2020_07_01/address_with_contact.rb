# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The address and contact details.
      AddressWithContact = Structure.new do
        attribute?(:address, Address)

        attribute?(:contact_details, ContactDetails, from: "contactDetails")
      end
    end
  end
end
