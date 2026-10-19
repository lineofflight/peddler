# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Finances20240619
      # All information relevant to a balance.
      Balance = Structure.new do
        # Total amount of the balance type.
        attribute?(:amount, Money)

        # The date for which the ending balance was calculated. This field is present when an `asOfDate` query parameter
        # is provided. Null for point-in-time balance queries.
        attribute?(:as_of_date, String, from: "asOfDate")

        # The type of balance. Known values: `AVAILABLE`, `RESERVED`, `ACCOUNT_LEVEL_RESERVE`, `DEFERRED`, `TOTAL`.
        attribute?(:balance_type, String, from: "balanceType")

        # A list of balances that comprise this balance.
        attribute?(:balances, [:self])

        # The date and time when the balance was last updated, in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The value is in the
        # marketplace's local time zone. This field is present for point-in-time balance queries (when no `asOfDate`
        # query parameter is provided). Null for ending balance queries.
        attribute?(:last_updated_time, Time, from: "lastUpdatedTime")

        # Metadata describing the seller.
        attribute?(:partner_metadata, PartnerMetadata, from: "partnerMetadata")
      end
    end
  end
end
