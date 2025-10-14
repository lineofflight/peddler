# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module ReportProcessingFinished
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [ReportProcessingFinishedNotification]
        attribute(:report_processing_finished_notification, ReportProcessingFinishedNotification, from: "reportProcessingFinishedNotification")
      end
    end
  end
end
