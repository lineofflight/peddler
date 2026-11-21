# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module EasyShip20220323
      # The request body for the POST /easyShip/2022-03-23/packages/bulk API.
      CreateScheduledPackagesRequest = Structure.new do
        # Known values: `PDF`, `ZPL`.
        attribute(:label_format, String, null: false, from: "labelFormat")

        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # An array allowing users to specify orders to be scheduled.
        attribute(:order_schedule_details_list, [OrderScheduleDetails], null: false, from: "orderScheduleDetailsList")
      end
    end
  end
end
