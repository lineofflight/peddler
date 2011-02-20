# encoding: utf-8

module Peddler

  # This module includes functionality to handle the charge-when-ship-related 
  # feeds Amazon added to the API in 2009.
  module Feeds

    # This is a downloadable file. Outputs Amazon's response verbatim for now.
    class Download
      attr_accessor :id, :type, :related_reference_id, :available_at, :acknowledged

      MAPPED_PARAMS = {
        'DownloadId'          => 'id',
        'DownloadType'        => 'type',
        'RelatedReferenceId'  => 'related_reference_id',
        'AvailableDate'       => 'available_at',
        'Acknowledged'        => 'acknowledged'}

      def initialize(transport, params={})
        @transport = transport
        params.each_pair{ |k, v| self.send "#{MAPPED_PARAMS[k]}=", v }
      end

      # Retrieves and returns report.
      def to_s
        @body ||= download_report
      end

      private

      def download_report
        return nil if @id.nil?
        @transport.modernize_request
        @transport.query_params.merge!({
          'Action'      => 'download',
          'downloadId'  => @id})
        @transport.execute_request
      end
    end

    # This is the base class.
    class Feed
      attr_writer   :file_content
      attr_accessor :batch, :download, :status, :type, :id, :submitted_at, :started_processing_at, :completed_processing_at, :messages_processed, :messages_successful, :messages_with_errors, :messages_with_warnings

      MAPPED_PARAMS = {
        'UploadStatus'              => 'status',
        'UploadType'                => 'type',
        'UploadId'                  => 'id',
        'SubmittedDate'             => 'submitted_at',
        'StartedProcessingDate'     => 'started_processing_at',
        'CompletedProcessingDate'   => 'completed_processing_at',
        'CompletedProcesssingDate'  => 'completed_processing_at',
        'MessagesProcessed'         => 'messages_processed',
        'MessagesSuccessful'        => 'messages_successful',
        'MessagesWithErrors'        => 'messages_with_errors',
        'MessagesWithWarnings'      => 'messages_with_warnings'}

      def initialize(transport)
        @transport = transport
        @batch = []
      end

      # Returns content of the upload file.
      def file_content
        return @file_content if @file_content 
        out = @file_header
        @batch.each{ |item| out << item.to_s }
        @file_content = out
      end

      # Returns status and will also refresh if not already "done."
      def status!
        return @status if @status.nil? || @status =~ /_DONE_/
        refresh_status
        @status
      end

      # Uploads batch.
      def upload
        raise PeddlerError.new('Batch already uploaded') unless @id.nil?
        @transport.modernize_request
        @transport.query_params.merge!({
          'Action'     => 'upload',
          'uploadType' => @type})
        @transport.body = file_content
        res = @transport.execute_request
        process_response(res)
        @status
      end

      # Adds an item to the batch.
      def <<(item)
        @batch << item
      end

      private

      def refresh_status
        @transport.modernize_request
        @transport.query_params.merge!({
          'Action'   => 'uploadStatus',
          'uploadId' => @id})
        res = @transport.execute_request
        process_response(res)
      end

      def process_response(res)
        upload = Hash.from_xml(res)['Response']['Upload'] || Hash.from_xml(res)['Response']['UploadsStatusList']['Upload']
        upload.each_pair do |key, value|
          if key == 'RelatedDownloadsList'
            @download = Peddler::Feeds::Download.new(@transport, value['Download'])
          else
            self.send "#{MAPPED_PARAMS[key]}=", value
          end
        end
      end
    end

    module OrderFulfillment
      # This class contains methods to upload order fulfillment info to Amazon.
      # See sections 7.1 through 7.3 in the API documentation for more detail.
      class Batch < Peddler::Feeds::Feed
        def initialize(transport)
          @file_header = "order-id\torder-item-id\tquantity\tship-date\tcarrier-code\tcarrier-name\ttracking-number\tship-method\r\n"
          @type = '_POST_FLAT_FILE_FULFILLMENT_DATA_'
          super(transport)
        end
      end

      # This is an order fulfillment item.
      class Item
        attr_accessor :order_id, :order_item_id, :quantity, :ship_date, :carrier_name, :tracking_number, :ship_method
        attr_reader   :carrier_code

        def initialize(params={})
          params.each_pair{ |key, value| send("#{key}=", value) }
        end

        # Validates when setting carrier code.
        def carrier_code=(carrier_code)
          @carrier_code = carrier_code if %w{USPS UPS FedEx other}.include?(carrier_code)
        end

        # Outputs a formatted line for the tab-delimited upload file.
        def to_s
          "#{@order_id}\t#{@order_item_id}\t#{@quantity}\t#{@ship_date}\t#{@carrier_code}\t#{@carrier_name}\t#{@tracking_number}\t#{@ship_method}\r\n"
        end
      end
    end

    # This module contains methods to upload cancelled orders to Amazon.
    # See section 7.4 in the API documentation for more detail.
    module OrderCancellation
      class Batch < Peddler::Feeds::Feed
        def initialize(transport)
          @file_header = "TemplateType=OrderCancellation  Version=1.0/1.0.3 This row for Amazon.com use only.  Do not modify or delete.\r\n" +
                         "order-id\tcancellation-reason-code\tamazon-order-item-code\r\n"
          @type = '_POST_FLAT_FILE_ORDER_ACKNOWLEDGEMENT_DATA_'
          super(transport)
        end
      end

      # This is a cancelled order item.
      class Item
        attr_accessor :order_id, :amazon_order_item_code
        attr_reader   :cancellation_reason_code

        def initialize(params={})
          params.each_pair{ |key, value| send("#{key}=", value) }
        end

        # Validates when setting cancellation reason code.
        def cancellation_reason_code=(cancellation_reason_code)
          @cancellation_reason_code = cancellation_reason_code if %w{ BuyerCanceled CustomerExchange CustomerReturn GeneralAdjustment MerchandiseNotReceived NoInventory ShippingAddressUndeliverable }.include?(cancellation_reason_code)
        end

        # Outputs a formatted line for the tab-delimited upload file.
        def to_s
          if @cancellation_reason_code.nil? != @amazon_order_item_code.nil?
            raise PeddlerError.new('Provide codes for both cancellation reason and Amazon order item (or omit both).')
          end
          "#{@order_id}\t#{@cancellation_reason_code}\t#{@amazon_order_item_code}\r\n"
        end
      end
    end
  end
end
