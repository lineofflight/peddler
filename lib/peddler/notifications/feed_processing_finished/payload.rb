# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeedProcessingFinished
      # Notification payload that wraps nested notification data
      Payload = Structure.new do
        # @return [FeedProcessingFinishedNotification]
        attribute(:feed_processing_finished_notification, FeedProcessingFinishedNotification, from: "feedProcessingFinishedNotification")
      end
    end
  end
end
