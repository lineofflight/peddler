# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Reports
    #
    #
    # Provides end user (customer) data to IE, ES, FR, BE, NL, DE, IT, SE, and PL selling partners. The data contains
    # customer personal data that includes contact information, page view (glance view), and order data for customers
    # that elect to share this data with specific sellers. The customer data is accessible across various reporting
    # periods (DAY, WEEK, and MONTH). Developers can choose start and end dates and the reporting period for data
    # retrieval and aggregation. If the customer does not elect to share their data, the report does not generate data.
    module EndUserData
      class << self
        def parse(hash)
          Report.parse(hash)
        end
      end
    end
  end
end
