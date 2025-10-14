# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
      # The request body for the POST /easyShip/2022-03-23/packages/bulk API.
      CreateScheduledPackagesRequest = Structure.new do
        # @return [String]
        attribute(:label_format, String, from: "labelFormat")

        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<OrderScheduleDetails>] An array allowing users to specify orders to be scheduled.
        attribute(:order_schedule_details_list, [OrderScheduleDetails], from: "orderScheduleDetailsList")
      end
    end
  end
end
