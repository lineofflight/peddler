# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def sales_v1(...)
      APIs::SalesV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for Sales
    #
    # The Selling Partner API for Sales provides APIs related to sales performance.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/sales.json
    class SalesV1 < API
      # Returns aggregated order metrics for given interval, broken down by granularity, for given buyer type.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified. For example, ATVPDKIKX0DER indicates the US
      #   marketplace.
      # @param interval [String] A time interval used for selecting order metrics. This takes the form of two dates
      #   separated by two hyphens (first date is inclusive; second date is exclusive). Dates are in ISO8601 format and
      #   must represent absolute time (either Z notation or offset notation). Example:
      #   2018-09-01T00:00:00-07:00--2018-09-04T00:00:00-07:00 requests order metrics for Sept 1st, 2nd and 3rd in the
      #   -07:00 zone.
      # @param granularity_time_zone [String] An IANA-compatible time zone for determining the day boundary. Required
      #   when specifying a granularity value greater than Hour. The granularityTimeZone value must align with the
      #   offset of the specified interval value. For example, if the interval value uses Z notation, then
      #   granularityTimeZone must be UTC. If the interval value uses an offset, then granularityTimeZone must be an
      #   IANA-compatible time zone that matches the offset. Example: US/Pacific to compute day boundaries, accounting
      #   for daylight time savings, for US/Pacific zone.
      # @param granularity [String] The granularity of the grouping of order metrics, based on a unit of time.
      #   Specifying granularity=Hour results in a successful request only if the interval specified is less than or
      #   equal to 30 days from now. For all other granularities, the interval specified must be less or equal to 2
      #   years from now. Specifying granularity=Total results in order metrics that are aggregated over the entire
      #   interval that you specify. If the interval start and end date don’t align with the specified granularity, the
      #   head and tail end of the response interval will contain partial data. Example: Day to get a daily breakdown of
      #   the request interval, where the day boundary is defined by the granularityTimeZone.
      # @param buyer_type [String] Filters the results by the buyer type that you specify, B2B (business to business) or
      #   B2C (business to customer). Example: B2B, if you want the response to include order metrics for only B2B
      #   buyers.
      # @param fulfillment_network [String] Filters the results by the fulfillment network that you specify, MFN
      #   (merchant fulfillment network) or AFN (Amazon fulfillment network). Do not include this filter if you want the
      #   response to include order metrics for all fulfillment networks. Example: AFN, if you want the response to
      #   include order metrics for only Amazon fulfillment network.
      # @param first_day_of_week [String] Specifies the day that the week starts on when granularity=Week, either Monday
      #   or Sunday. Default: Monday. Example: Sunday, if you want the week to start on a Sunday.
      # @param asin [String] Filters the results by the ASIN that you specify. Specifying both ASIN and SKU returns an
      #   error. Do not include this filter if you want the response to include order metrics for all ASINs. Example:
      #   B0792R1RSN, if you want the response to include order metrics for only ASIN B0792R1RSN.
      # @param sku [String] Filters the results by the SKU that you specify. Specifying both ASIN and SKU returns an
      #   error. Do not include this filter if you want the response to include order metrics for all SKUs. Example:
      #   TestSKU, if you want the response to include order metrics for only SKU TestSKU.
      # @param amazon_program [String] Filters the results by the Amazon program that you specify. Do not include this
      #   filter if you want the response to include order metrics for all programs. **Example:** `AmazonHaul` returns
      #   order metrics for the Amazon Haul program only.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_order_metrics(marketplace_ids, interval, granularity, granularity_time_zone: nil, buyer_type: "All",
        fulfillment_network: nil, first_day_of_week: "Monday", asin: nil, sku: nil, amazon_program: nil,
        rate_limit: 0.5)
        path = "/sales/v1/orderMetrics"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
          "interval" => interval,
          "granularityTimeZone" => granularity_time_zone,
          "granularity" => granularity,
          "buyerType" => buyer_type,
          "fulfillmentNetwork" => fulfillment_network,
          "firstDayOfWeek" => first_day_of_week,
          "asin" => asin,
          "sku" => sku,
          "amazonProgram" => amazon_program,
        }.compact
        parser = Peddler::Types::SalesV1::GetOrderMetricsResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      private

      def load_types
        require "peddler/types/sales_v1"
      end
    end
  end
end
