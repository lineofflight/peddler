# frozen_string_literal: true

require 'peddler/client'

module MWS
  module ShipmentInvoicing
    # With the Shipment Invoicing API section, you can integrate invoicing into
    # Amazon's shipping process for a seller's FBA order.
    #
    # @note This functionality is available only in the Brazil marketplace.
    class Client < ::Peddler::Client
      self.version = '2018-09-01'
      self.path = "/ShipmentInvoicing/#{version}"

      # Returns the information required to generate an invoice for the shipment
      # of a Fulfillment by Amazon order
      #
      # @see https://docs.developer.amazonservices.com/en_US/shipment_invoicing/ShipmentInvoicing_GetFBAOutboundShipmentDetail.html
      # @param [String] marketplace_id
      # @param [String] amazon_shipment_id
      # @return [Peddler::XMLParser]
      def get_fba_outbound_shipment_detail(marketplace_id, amazon_shipment_id)
        operation('GetFBAOutboundShipmentDetail')
          .add('MarketplaceId' => marketplace_id,
               'AmazonShipmentId' => amazon_shipment_id)

        run
      end

      # Submits shipment invoice data for a given shipment
      #
      # @see https://docs.developer.amazonservices.com/en_US/shipment_invoicing/ShipmentInvoicing_SubmitFBAOutboundShipmentInvoice.html
      # @param [String] marketplace_id
      # @param [String] amazon_shipment_id
      # @param [String] invoice_content
      # @return [Peddler::XMLParser]
      def submit_fba_outbound_shipment_invoice(marketplace_id,
                                               amazon_shipment_id,
                                               invoice_content)
        self.body = invoice_content

        operation('SubmitFBAOutboundShipmentInvoice')
          .add('MarketplaceId' => marketplace_id,
               'AmazonShipmentId' => amazon_shipment_id)

        run
      end

      # Gets the invoice processing status for the shipments that you specify
      #
      # @see https://docs.developer.amazonservices.com/en_US/shipment_invoicing/ShipmentInvoicing_GetFBAOutboundShipmentInvoiceStatus.html
      # @param [String] marketplace_id
      # @param [String] amazon_shipment_id
      # @return [Peddler::XMLParser]
      def get_fba_outbound_shipment_invoice_status(marketplace_id,
                                                   amazon_shipment_id)
        operation('GetFBAOutboundShipmentInvoiceStatus')
          .add('MarketplaceId' => marketplace_id,
               'AmazonShipmentId' => amazon_shipment_id)

        run
      end

      # Gets the operational status of the API
      #
      # @see https://docs.developer.amazonservices.com/en_US/shipment_invoicing/ShipmentInvoicing_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
