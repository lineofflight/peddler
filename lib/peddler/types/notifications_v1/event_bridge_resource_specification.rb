# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module NotificationsV1
      # The information required to create an Amazon EventBridge destination.
      EventBridgeResourceSpecification = Structure.new do
        # @return [String] The AWS region in which you will be receiving the notifications.
        attribute(:region, String)

        # @return [String] The identifier for the AWS account that is responsible for charges related to receiving
        # notifications.
        attribute(:account_id, String, from: "accountId")
      end
    end
  end
end
