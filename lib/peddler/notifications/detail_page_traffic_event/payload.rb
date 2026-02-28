# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module DetailPageTrafficEvent
      # Notification payload data
      Payload = Structure.new do
        # @return [Array<DetailPageTrafficEvent>]
        attribute(:detail_page_traffic_events, [DetailPageTrafficEvent], null: false, from: "detailPageTrafficEvents")
      end
    end
  end
end
