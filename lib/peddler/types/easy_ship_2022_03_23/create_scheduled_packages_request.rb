# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/easy_ship_2022_03_23/order_schedule_details"

module Peddler
  module Types
    module EasyShip20220323
      # The request body for the POST /easyShip/2022-03-23/packages/bulk API.
      CreateScheduledPackagesRequest = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<OrderScheduleDetails>] An array allowing users to specify orders to be scheduled.
        attribute(:order_schedule_details_list, [OrderScheduleDetails], from: "orderScheduleDetailsList")

        # @return [String]
        attribute(:label_format, String, from: "labelFormat")
      end
    end
  end
end
