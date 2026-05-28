# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class NotificationsV1
      # The describer for the test notification that will be delivered.
      TestNotification = Structure.new do
        # @return [String] The version of the payload object to be used in the notification.
        attribute(:payload_version, String, null: false, from: "payloadVersion")

        # @return [String] The scenario of the specified notification to be used in the notification payload. If
        #   testScenario is empty, a 400 response will be returned back to the developer. The scenarios supported for
        #   each notification type can be found in the Selling Partner API Developer Guide.
        attribute?(:test_scenario, String, from: "testScenario")
      end
    end
  end
end
