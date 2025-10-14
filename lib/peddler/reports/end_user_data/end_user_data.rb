# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module EndUserData
      # Contains end user contact information, page view and GMS metrics.
      EndUserData = Structure.new do
        # @return [Array<AsinMetrics>] A list of Asin Page View and GMS metrics of an end user.
        attribute(:asin_metrics, [ASINMetrics], from: "asinMetrics")

        # @return [String] Full Name of the end user.
        attribute(:full_name, String, from: "fullName")

        # @return [Hash] Mailing address of the end user.
        attribute(:mailing_address, Hash, from: "mailingAddress")

        # @return [String] Primary email of the end user.
        attribute(:primary_email, String, from: "primaryEmail")
      end
    end
  end
end
