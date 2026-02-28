# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Reports20210630
      # Response schema.
      CreateReportScheduleResponse = Structure.new do
        # @return [String] The identifier for the report schedule. This identifier is unique only in combination with a
        #   seller ID.
        attribute(:report_schedule_id, String, null: false, from: "reportScheduleId")
      end
    end
  end
end
