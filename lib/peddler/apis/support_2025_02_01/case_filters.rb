# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module Support20250201
      # Optional filters for case search. All filters are optional — when absent, no filtering is applied for that
      # field. Different filters are combined with AND logic, and multiple values of the same field are combined with OR
      # logic.
      CaseFilters = Structure.new do
        # Filter the collection by one or more case statuses. Known values: `RESOLVED`, `TRANSFERRED`,
        # `PENDING_MERCHANT_ACTION`, `PENDING_AMAZON_ACTION`.
        attribute?(:case_statuses, [String], from: "caseStatuses")

        # Filter the collection by one or more CC email addresses.
        attribute?(:cc_emails, [String], from: "ccEmails")

        # Filter the collection by case creation date.
        attribute?(:created_date, DateFilter, from: "createdDate")

        # Filter the collection by last outbound contact date.
        attribute?(:last_outbound_date, DateFilter, from: "lastOutboundDate")

        # Filter the collection by primary email address.
        attribute?(:primary_emails, [String], from: "primaryEmails")

        # Filter the collection by case resolution date.
        attribute?(:resolved_date, DateFilter, from: "resolvedDate")

        # Filter the collection by case subject keywords. Maximum 200 characters.
        attribute?(:subject_keywords, String, from: "subjectKeywords")
      end
    end
  end
end
