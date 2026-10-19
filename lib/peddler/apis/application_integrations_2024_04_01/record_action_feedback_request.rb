# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ApplicationIntegrations20240401
      # The request for the `recordActionFeedback` operation.
      RecordActionFeedbackRequest = Structure.new do
        # The unique identifier for each notification status. Known values: `SELLER_ACTION_COMPLETED`.
        attribute(:feedback_action_code, String, null: false, from: "feedbackActionCode")
      end
    end
  end
end
