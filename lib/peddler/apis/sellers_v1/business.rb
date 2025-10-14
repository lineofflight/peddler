# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SellersV1
      # Information about the seller's business. Certain fields may be omitted depending on the seller's `businessType`.
      Business = Structure.new do
        # @return [String] The registered business name.
        attribute(:name, String)

        # @return [Address] The registered business address.
        attribute(:registered_business_address, Address, from: "registeredBusinessAddress")

        # @return [String] The seller's company registration number, if applicable. This field will be absent for
        # individual sellers and sole proprietorships.
        attribute?(:company_registration_number, String, from: "companyRegistrationNumber")

        # @return [String] The seller's company tax identification number, if applicable. This field will be present for
        # certain business types only, such as sole proprietorships.
        attribute?(:company_tax_identification_number, String, from: "companyTaxIdentificationNumber")

        # @return [String] The non-Latin script version of the registered business name, if applicable.
        attribute?(:non_latin_name, String, from: "nonLatinName")
      end
    end
  end
end
