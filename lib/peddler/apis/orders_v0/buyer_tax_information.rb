# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # Contains the business invoice tax information. Available only in the TR marketplace.
      BuyerTaxInformation = Structure.new do
        # Business buyer's address.
        attribute?(:buyer_business_address, String, from: "BuyerBusinessAddress")

        # Business buyer's company legal name.
        attribute?(:buyer_legal_company_name, String, from: "BuyerLegalCompanyName")

        # Business buyer's tax office.
        attribute?(:buyer_tax_office, String, from: "BuyerTaxOffice")

        # Business buyer's tax registration ID.
        attribute?(:buyer_tax_registration_id, String, from: "BuyerTaxRegistrationId")
      end
    end
  end
end
