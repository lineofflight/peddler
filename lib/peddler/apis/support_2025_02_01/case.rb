# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Support20250201
      # The support case.
      Case = Structure.new do
        # A globally unique identifier for the case
        attribute(:case_id, String, null: false, from: "caseId")

        # Additional emails that are attached to the case.
        attribute(:cc_emails, [String], null: false, from: "ccEmails")

        # The time when the case was created. In [ISO 8601](https://developer-docs.amazon/sp-api/docs/iso-8601) format.
        attribute(:created_date, Time, null: false, from: "createdDate")

        # The time when the case was last updated, which includes updates to the case details and new contacts added to
        # the case. In [ISO 8601](https://developer-docs.amazon/sp-api/docs/iso-8601) format.
        attribute(:last_updated_date, Time, null: false, from: "lastUpdatedDate")

        # The primary email associated with the case.
        attribute(:primary_email, String, null: false, from: "primaryEmail")

        # The current status of the case. Known values: `RESOLVED`, `TRANSFERRED`, `PENDING_MERCHANT_ACTION`,
        # `PENDING_AMAZON_ACTION`.
        attribute(:status, String, null: false)

        # The subject of the case.
        attribute(:subject, String, null: false)

        # All appointments for the case.
        attribute?(:appointments, [Appointment])

        # The timestamp of the last outbound contact on the case. The date must be in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute?(:last_outbound_date, Time, from: "lastOutboundDate")

        # The time when the case was resolved. In [ISO 8601](https://developer-docs.amazon/sp-api/docs/iso-8601) format.
        attribute?(:resolved_date, Time, from: "resolvedDate")
      end
    end
  end
end
