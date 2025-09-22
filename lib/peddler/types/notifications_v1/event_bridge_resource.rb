# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module NotificationsV1
      # The Amazon EventBridge destination.
      EventBridgeResource = Structure.new do
        # @return [String] The name of the partner event source associated with the destination.
        attribute(:name, String)

        # @return [String] The AWS region in which you receive the notifications. For AWS regions that are supported in
        # Amazon EventBridge, refer to [Amazon EventBridge endpoints and
        # quotas](https://docs.aws.amazon.com/general/latest/gr/ev.html).
        attribute(:region, String)

        # @return [String] The identifier for the AWS account that is responsible for charges related to receiving
        # notifications.
        attribute(:account_id, String, from: "accountId")
      end
    end
  end
end
