# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module Notifications
    # The root schema
    #
    # The root schema comprises the entire JSON document.
    module AnyOfferChanged
      class << self
        def parse(hash)
          Notification.parse(hash)
        end
      end
    end
  end
end
