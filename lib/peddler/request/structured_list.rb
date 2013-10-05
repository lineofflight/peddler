module Peddler
  class Request
    class StructuredList
      KEYS = {
        # Feeds
        feed_submission_id_list: %w(FeedSubmissionIdList Id),
        feed_type_list: %w(FeedTypeList Type),
        feed_processing_status_list: %w(FeedProcessingStatusList Status),
        # Orders
        order_status: %w(OrderStatus Status),
        marketplace_id: %w(MarketplaceId Id),
        fulfillment_channel: %w(FulfillmentChannel Channel),
        payment_method: %w(PaymentMethod),
        tfm_shipment_status: %w(TFMShipmentStatus Status),
        amazon_order_id: %w(AmazonOrderId Id),
        # Reports
        report_request_id_list: %w(ReportRequestIdList Id),
        report_type_list: %w(ReportTypeList Type),
        report_processing_status_list: %w(ReportProcessingStatusList Status),
      }

      attr :keys

      def self.handle?(key)
        KEYS.has_key?(key)
      end

      def initialize(key)
        @keys = KEYS.fetch(key)
      end

      def build(values)
        Array(values)
          .each_with_index
          .reduce(Hash.new) { |hsh, (v, i)|
            hsh.merge(composite_key(i + 1) => v)
          }
      end

      private

      def composite_key(index)
        (keys.dup << index).join('.')
      end
    end
  end
end
