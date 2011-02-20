# encoding: utf-8

module Peddler
  module Refunds
    # This is a refund batch.
    class Batch
      attr_accessor :batch

      def initialize(transport)
        @transport = transport
        @batch = []
      end

      def file_content
        out = "order-id\tpayments-transaction-id\trefund-amount\treason\tmessage\r\n"
        @file_content = @batch.inject(out){ |memo, item| memo << item.to_s }
      end

      def <<(item)
        @batch << item
      end

      def upload
        raise PeddlerError.new("Batch already uploaded") if @completed
        @transport.legacize_request
        @transport.path << "catalog-upload/batch-refund"
        @transport.body = file_content
        res = @transport.execute_request
        @completed = true if res == "<Success>SUCCESS</Success>"
      end

    end

    # This is a refund.
    class Item
      REFUND_REASONS = %w{ GeneralAdjustment CouldNotShip DifferentItem MerchandiseNotReceived MerchandiseNotAsDescribed }

      attr_accessor :order_id, :payments_transaction_id, :refund_amount, :message
      attr_reader   :reason

      def initialize(options={})
        options.each_pair{ |key, value| send("#{key.to_s}=", value) }
      end

      def reason=(reason)
        @reason = reason if REFUND_REASONS.include?(reason)
      end

      def to_s
        "#{self.order_id}\t#{self.payments_transaction_id}\t#{self.refund_amount}\t#{self.reason}\t#{self.message}\r\n"
      end
    end
  end
end
