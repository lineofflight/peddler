# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Easy Ship
    #
    # Use the Selling Partner API for Easy Ship to build applications for sellers to manage and ship Amazon Easy Ship
    # orders. With this API, you can get available time slots, schedule and reschedule Easy Ship orders, and print
    # shipping labels, invoices, and warranties. To review the differences in Easy Ship operations by marketplace, refer
    # to [Marketplace
    # support](https://developer-docs.amazon.com/sp-api/docs/easyship-api-v2022-03-23-use-case-guide#marketplace-support).
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/easy-ship-model/easyShip_2022-03-23.json
    module EasyShip20220323
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "easy_ship_2022_03_23.create_scheduled_package" => -> { Package },
        "easy_ship_2022_03_23.create_scheduled_package_bulk" => -> { CreateScheduledPackagesResponse },
        "easy_ship_2022_03_23.get_scheduled_package" => -> { Package },
        "easy_ship_2022_03_23.list_handover_slots" => -> { ListHandoverSlotsResponse },
        "easy_ship_2022_03_23.update_scheduled_packages" => -> { Packages },
      })
    end
  end
end
