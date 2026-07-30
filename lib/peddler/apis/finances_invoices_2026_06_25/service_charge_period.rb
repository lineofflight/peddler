# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # The time period for a service charge.
      ServiceChargePeriod = Structure.new do
        # @return [Time] When the service charge period ends. In ISO 8601 format.
        attribute(:end_date, Time, null: false, from: "endDate")

        # @return [Time] When the service charge period starts. In ISO 8601 format.
        attribute(:start_date, Time, null: false, from: "startDate")
      end
    end
  end
end
