# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def invoices_2024_06_19(...)
      APIs::Invoices20240619.new(...)
    end
  end

  module APIs
    # The Selling Partner API for Invoices.
    #
    # Use the Selling Partner API for Invoices to retrieve and manage invoice-related operations, which can help selling
    # partners manage their bookkeeping processes.
    class Invoices20240619 < API
      # Returns marketplace-dependent schemas and their respective set of possible values.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] The marketplace identifier.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_invoices_attributes(marketplace_id, rate_limit: 1.0)
        path = "/tax/invoices/2024-06-19/attributes"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns the invoice document's ID and URL. Use the URL to download the ZIP file, which contains the invoices
      # from the corresponding `createInvoicesExport` request.
      #
      # @note This operation can make a static sandbox call.
      # @param invoices_document_id [String] The export document identifier.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_invoices_document(invoices_document_id, rate_limit: 0.0167)
        path = "/tax/invoices/2024-06-19/documents/#{percent_encode(invoices_document_id)}"

        meter(rate_limit).get(path)
      end

      # Creates an invoice export request.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Information required to create the export request.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_invoices_export(body, rate_limit: 0.167)
        path = "/tax/invoices/2024-06-19/exports"

        meter(rate_limit).post(path, body:)
      end

      # Returns invoice exports details for exports that match the filters that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] The returned exports match the specified marketplace.
      # @param date_start [String] The earliest export creation date and time for exports that you want to include in
      #   the response. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time
      #   format. The default is 30 days ago.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   `pageSize` value. To get the next page of results, call the operation with this token and include the same
      #   arguments as the call that produced the token. To get a complete list, call this operation until `nextToken`
      #   is null. Note that this operation can return empty pages.
      # @param page_size [Integer] The maximum number of invoices to return in a single call. Minimum: 1 Maximum: 100
      # @param date_end [String] The latest export creation date and time for exports that you want to include in the
      #   response. Values are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      #   The default value is the time of the request.
      # @param status [String] Return exports matching the status specified.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_invoices_exports(marketplace_id, date_start: nil, next_token: nil, page_size: nil, date_end: nil,
        status: nil, rate_limit: 0.1)
        path = "/tax/invoices/2024-06-19/exports"
        params = {
          "marketplaceId" => marketplace_id,
          "dateStart" => date_start,
          "nextToken" => next_token,
          "pageSize" => page_size,
          "dateEnd" => date_end,
          "status" => status,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns invoice export details (including the `exportDocumentId`, if available) for the export that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param export_id [String] The unique identifier for the export.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_invoices_export(export_id, rate_limit: 2.0)
        path = "/tax/invoices/2024-06-19/exports/#{percent_encode(export_id)}"

        meter(rate_limit).get(path)
      end

      # Returns invoice details for the invoices that match the filters that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param transaction_identifier_name [String] The name of the transaction identifier filter. If you provide a
      #   value for this field, you must also provide a value for the `transactionIdentifierId` field.Use the
      #   `getInvoicesAttributes` operation to check `transactionIdentifierName` options.
      # @param page_size [Integer] The maximum number of invoices you want to return in a single call. Minimum: 1
      #   Maximum: 200
      # @param date_end [String] The latest invoice creation date for invoices that you want to include in the response.
      #   Dates are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format. The default
      #   is the current date-time.
      # @param marketplace_id [String] The response includes only the invoices that match the specified marketplace.
      # @param transaction_type [String] The marketplace-specific classification of the transaction type for which the
      #   invoice was created. Use the `getInvoicesAttributes` operation to check `transactionType` options.
      # @param transaction_identifier_id [String] The ID of the transaction identifier filter. If you provide a value
      #   for this field, you must also provide a value for the `transactionIdentifierName` field.
      # @param date_start [String] The earliest invoice creation date for invoices that you want to include in the
      #   response. Dates are in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      #   The default is 24 hours prior to the time of the request.
      # @param series [String] Return invoices with the specified series number.
      # @param next_token [String] The response includes `nextToken` when the number of results exceeds the specified
      #   `pageSize` value. To get the next page of results, call the operation with this token and include the same
      #   arguments as the call that produced the token. To get a complete list, call this operation until `nextToken`
      #   is null. Note that this operation can return empty pages.
      # @param sort_order [String] Sort the invoices in the response in ascending or descending order.
      # @param invoice_type [String] The marketplace-specific classification of the invoice type. Use the
      #   `getInvoicesAttributes` operation to check `invoiceType` options.
      # @param statuses [Array<String>] A list of statuses that you can use to filter invoices. Use the
      #   `getInvoicesAttributes` operation to check invoice status options. Min count: 1
      # @param external_invoice_id [String] Return invoices that match this external ID. This is typically the
      #   Government Invoice ID.
      # @param sort_by [String] The attribute by which you want to sort the invoices in the response.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_invoices(marketplace_id, transaction_identifier_name: nil, page_size: nil, date_end: nil,
        transaction_type: nil, transaction_identifier_id: nil, date_start: nil, series: nil, next_token: nil,
        sort_order: nil, invoice_type: nil, statuses: nil, external_invoice_id: nil, sort_by: nil, rate_limit: 0.1)
        path = "/tax/invoices/2024-06-19/invoices"
        params = {
          "transactionIdentifierName" => transaction_identifier_name,
          "pageSize" => page_size,
          "dateEnd" => date_end,
          "marketplaceId" => marketplace_id,
          "transactionType" => transaction_type,
          "transactionIdentifierId" => transaction_identifier_id,
          "dateStart" => date_start,
          "series" => series,
          "nextToken" => next_token,
          "sortOrder" => sort_order,
          "invoiceType" => invoice_type,
          "statuses" => stringify_array(statuses),
          "externalInvoiceId" => external_invoice_id,
          "sortBy" => sort_by,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Returns invoice data for the specified invoice. This operation returns only a subset of the invoices data; refer
      # to the response definition to get all the possible attributes.
      # To get the full invoice, use the `createInvoicesExport` operation to start an export request.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] The marketplace from which you want the invoice.
      # @param invoice_id [String] The invoice identifier.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_invoice(marketplace_id, invoice_id, rate_limit: 2.0)
        path = "/tax/invoices/2024-06-19/invoices/#{percent_encode(invoice_id)}"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        meter(rate_limit).get(path, params:)
      end
    end
  end
end
