# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Reports20210630
      # The response schema.
      CreateReportResponse = Structure.new do
        # The identifier for the report. This identifier is unique only in combination with a seller ID.
        attribute(:report_id, String, null: false, from: "reportId")
      end
    end
  end
end
