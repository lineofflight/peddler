# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Finances20240619
      # Contains all information related to the financial summary.
      Summary = Structure.new do
        # A list of breakdowns that detail how the net proceeds are calculated.
        attribute?(:breakdowns, [Breakdown])

        # The net proceeds for the summary period.
        attribute?(:net_proceeds, Money, from: "netProceeds")

        # Metadata describing the seller.
        attribute?(:partner_metadata, PartnerMetadata, from: "partnerMetadata")

        # The end date and time of the summary.
        attribute?(:period_end, String, from: "periodEnd")

        # The start date and time of the summary.
        attribute?(:period_start, String, from: "periodStart")

        # Identifiers related to the summary, such as the settlement ID.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "relatedIdentifiers")
      end
    end
  end
end
