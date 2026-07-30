# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # Metadata about a partner (payer or payee) associated with the invoice.
      PartnerMetadata = Structure.new do
        # @return [String] The unique identifier for the partner. If the partner is a vendor, then this value is the
        #   `vendorGroupID`.
        attribute(:partner_id, String, null: false, from: "partnerId")

        # @return [String] The type of partner.
        attribute(:partner_type, String, null: false, from: "partnerType")

        # @return [String] The address of the partner.
        attribute?(:partner_address, String, from: "partnerAddress")

        # @return [Array<String>] The list of entities associated with a partner.
        attribute?(:partner_entities, [String], from: "partnerEntities")

        # @return [String] The name of the partner.
        attribute?(:partner_name, String, from: "partnerName")

        # @return [String] The tax registration number of the partner.
        attribute?(:tax_registration_number, String, from: "taxRegistrationNumber")
      end
    end
  end
end
