# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module MfnOrderStatusChange
      # Notification payload data
      Payload = Structure.new do
        # @return [Hash]
        attribute(:mfn_order_status_change_notification, Hash, from: "MFNOrderStatusChangeNotification")
      end
    end
  end
end
