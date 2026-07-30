# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Finances20240619
      # All information relevant to a balance.
      Balance = Structure.new do
        # @return [Money] Total amount of the balance type.
        attribute?(:amount, Money)

        # @return [String] The date for which the ending balance was calculated. This field is present when an
        #   `asOfDate` query parameter is provided. Null for point-in-time balance queries.
        attribute?(:as_of_date, String, from: "asOfDate")

        # @return [String] The type of balance.
        attribute?(:balance_type, String, from: "balanceType")

        # @return [Array<self>] A list of balances that comprise this balance.
        attribute?(:balances, [:self])

        # @return [Time] The date and time when the balance was last updated, in [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The value is in the
        #   marketplace's local time zone. This field is present for point-in-time balance queries (when no `asOfDate`
        #   query parameter is provided). Null for ending balance queries.
        attribute?(:last_updated_time, Time, from: "lastUpdatedTime")

        # @return [PartnerMetadata] Metadata describing the seller.
        attribute?(:partner_metadata, PartnerMetadata, from: "partnerMetadata")
      end
    end
  end
end
