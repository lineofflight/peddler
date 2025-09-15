# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ApplicationIntegrations20240401
      # The request for the `recordActionFeedback` operation.
      RecordActionFeedbackRequest = Structure.new do
        # @return [String] The unique identifier for each notification status.
        attribute(:feedback_action_code, String, from: "feedbackActionCode")
      end
    end
  end
end
