# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Reports20210630
      # The response schema.
      CreateReportResponse = Structure.new do
        # @return [String] The identifier for the report. This identifier is unique only in combination with a seller
        # ID.
        attribute(:report_id, String, from: "reportId")
      end
    end
  end
end
