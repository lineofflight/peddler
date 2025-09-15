# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Reports20210630
      # Response schema.
      CreateReportScheduleResponse = Structure.new do
        # @return [String] The identifier for the report schedule. This identifier is unique only in combination with a
        # seller ID.
        attribute(:report_schedule_id, String, from: "reportScheduleId")
      end
    end
  end
end
