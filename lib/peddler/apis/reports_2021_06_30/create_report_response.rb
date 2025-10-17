# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Reports20210630
      # The response schema.
      CreateReportResponse = Structure.new do
        # @return [String] The identifier for the report. This identifier is unique only in combination with a seller
        #   ID.
        attribute(:report_id, String, from: "reportId")
      end
    end
  end
end
