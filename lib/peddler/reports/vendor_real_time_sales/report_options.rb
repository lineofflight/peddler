# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorRealTimeSales
      # Report options specifying parameters such as currencyCode.
      ReportOptions = Structure.new do
        # @return [String] Currency code of the amount. In ISO 4217 format.
        attribute(:currency_code, String, null: false, from: "currencyCode")
      end
    end
  end
end
