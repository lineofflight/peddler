# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Support20250201
      # The support case.
      Case = Structure.new do
        # @return [String] A globally unique identifier for the case
        attribute(:case_id, String, null: false, from: "caseId")

        # @return [Array<String>] Additional emails that are attached to the case.
        attribute(:cc_emails, [String], null: false, from: "ccEmails")

        # @return [Time] The time when the case was created. In [ISO
        #   8601](https://developer-docs.amazon/sp-api/docs/iso-8601) format.
        attribute(:created_date, Time, null: false, from: "createdDate")

        # @return [Time] The time when the case was last updated, which includes updates to the case details and new
        #   contacts added to the case. In [ISO 8601](https://developer-docs.amazon/sp-api/docs/iso-8601) format.
        attribute(:last_updated_date, Time, null: false, from: "lastUpdatedDate")

        # @return [String] The primary email associated with the case.
        attribute(:primary_email, String, null: false, from: "primaryEmail")

        # @return [String] The current status of the case.
        attribute(:status, String, null: false)

        # @return [String] The subject of the case.
        attribute(:subject, String, null: false)

        # @return [Array<Appointment>] All appointments for the case.
        attribute?(:appointments, [Appointment])

        # @return [Time] The timestamp of the last outbound contact on the case. The date must be in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute?(:last_outbound_date, Time, from: "lastOutboundDate")

        # @return [Time] The time when the case was resolved. In [ISO
        #   8601](https://developer-docs.amazon/sp-api/docs/iso-8601) format.
        attribute?(:resolved_date, Time, from: "resolvedDate")
      end
    end
  end
end
