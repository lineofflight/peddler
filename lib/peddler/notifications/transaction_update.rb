# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Notifications
    # The root schema
    #
    # The notification response schema that comprises the entire JSON document for the notification.
    module TransactionUpdate
      class << self
        def parse(hash)
          Notification.parse(hash)
        end
      end
    end
  end
end
