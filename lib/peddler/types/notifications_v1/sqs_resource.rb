# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module NotificationsV1
      # The information required to create an Amazon Simple Queue Service (Amazon SQS) queue destination.
      SqsResource = Structure.new do
        # @return [String] The Amazon Resource Name (ARN) associated with the SQS queue.
        attribute(:arn, String)
      end
    end
  end
end
