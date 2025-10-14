# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module EndUserData
      # Provides end user (customer) data to IE, ES, FR, BE, NL, DE, IT, SE, and PL selling partners. The data contains
      # customer personal data that includes contact information, page view (glance view), and order data for customers
      # that elect to share this data with specific sellers. The customer data is accessible across various reporting
      # periods (DAY, WEEK, and MONTH). Developers can choose start and end dates and the reporting period for data
      # retrieval and aggregation. If the customer does not elect to share their data, the report does not generate
      # data.
      Report = Structure.new do
        # @return [Array<EndUserData>] A list of consented end users (buyers) and their data.
        attribute(:end_user_data, [EndUserData], from: "endUserData")

        # @return [Hash] Summarizes the report request.
        attribute(:report_specification, ReportSpecification, from: "reportSpecification")
      end
    end
  end
end
