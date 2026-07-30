# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Finances20240619
      # Contains all information related to the financial summary.
      Summary = Structure.new do
        # @return [Array<Breakdown>] A list of breakdowns that detail how the net proceeds are calculated.
        attribute?(:breakdowns, [Breakdown])

        # @return [Money] The net proceeds for the summary period.
        attribute?(:net_proceeds, Money, from: "netProceeds")

        # @return [PartnerMetadata] Metadata describing the seller.
        attribute?(:partner_metadata, PartnerMetadata, from: "partnerMetadata")

        # @return [String] The end date and time of the summary.
        attribute?(:period_end, String, from: "periodEnd")

        # @return [String] The start date and time of the summary.
        attribute?(:period_start, String, from: "periodStart")

        # @return [Array<RelatedIdentifier>] Identifiers related to the summary, such as the settlement ID.
        attribute?(:related_identifiers, [RelatedIdentifier], from: "relatedIdentifiers")
      end
    end
  end
end
