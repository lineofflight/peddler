# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ApplicationIntegrations20240401
      # The request for the `recordActionFeedback` operation.
      RecordActionFeedbackRequest = Structure.new do
        # @return [String] The unique identifier for each notification status.
        attribute(:feedback_action_code, String, from: "feedbackActionCode")
      end
    end
  end
end
