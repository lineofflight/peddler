# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # A fee applied to a given product in the seller's account within a given date
      # range. Fee information can be found
      # [here](https://sellercentral.amazon.com/gp/help/GZ8Y22NL2FSRY8M5).
      Fee = Structure.new do
        # @return [AggregatedDetail] Fee aggregated transaction detail.
        attribute?(:aggregated_detail, AggregatedDetail, from: "aggregatedDetail")

        # @return [Array<FeeComponent>] A breakdown of the fee into individual components. This field will be null for
        # fee types that cannot be divided into individual components.
        attribute?(:components, [FeeComponent])

        # @return [String] The end date of the seller economics data for current fee. In most cases, this
        # value is the same as the request 'endDate'. However, when the request date
        # range includes the Amazon fee change date, in order to better show the impact
        # of the Amazon fee changes before and after the fee change date, the response
        # will split the request date range and display the fee separately. This will
        # cause the 'endDate' in 'Fee' to be different than the request 'endDate'.
        # Example: If the request date range is [2024-07-01, 2024-07-30] and the Amazon
        # fee change date is 2024-07-15, then the request date range will be split into
        # [2024-07-01, 2024-07-14], [2024-07-15, 2024-07-30].
        attribute?(:end_date, String, from: "endDate")

        # @return [String] A unique identifier used to track this fee
        attribute?(:identifier, String)

        # @return [Array<EconomicsProperty>] The properties used to calculate the 'aggregatedDetail' value in 'Fee'.
        # Example: Product Size Tier, an important property that determines the
        # amountPerUnit of FBA_FULFILLMENT_FEE.
        attribute?(:properties, [EconomicsProperty])

        # @return [String] The start date of the seller economics data for current fee. In most cases,
        # this value is the same as the request 'startDate'. However, when the request
        # date range includes the Amazon fee change date, in order to better show the
        # impact of the Amazon fee changes before and after the fee change date, the
        # response will split the request date range and display the fee separately.
        # This will cause the 'startDate' in 'Fee' to be different than the request 'startDate'.
        # Example: If the request date range is [2024-07-01, 2024-07-30] and the Amazon
        # fee change date is 2024-07-15, then the request date range will be split into
        # [2024-07-01, 2024-07-14], [2024-07-15, 2024-07-30].
        attribute?(:start_date, String, from: "startDate")
      end
    end
  end
end
