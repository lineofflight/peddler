# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Invoices
    #
    # The Selling Partner API for Invoices enables you to retrieve invoice data and streamline your bookkeeping
    # processes.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/finances-api-model/financesInvoices_2026-06-25.json
    class FinancesInvoices20260625 < API
      # Returns invoice headers for all invoices matching filters that you specify.
      #
      # @note This operation can make a static sandbox call.
      # @param next_token [String] The response includes `nextToken` when the number of invoices exceeds the default
      #   page size value (100). To get the next page of results, call the operation with this token and include the
      #   same arguments as the call that produced the token. To get a complete list, call this operation until
      #   `nextToken` is `null`. Note that this operation can return empty pages.
      # @param marketplace_id [String] The marketplace ID of the marketplace from which you want to retrieve invoice
      #   headers. The marketplace ID is a globally unique identifier used to specify which Amazon marketplace a request
      #   is targeting. For more information, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param from_issue_date [String] Retrieve invoice headers issued after this date. The range between
      #   `fromIssueDate` and `toIssueDate` must not exceed 90 days. Either provide both dates or leave both empty. If
      #   you do not provide these dates, `fromIssueDate` defaults to 90 days before the date of the request. In [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param to_issue_date [String] Retrieve invoice headers issued before this date. The range between
      #   `fromIssueDate` and `toIssueDate` must not exceed 90 days. Either provide both dates or leave both empty. If
      #   you do not provide these dates, `toIssueDate` defaults to the date of the request. In [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @param invoices_modified_after [String] Retrieve invoices that were modified after this date-time. In [ISO
      #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format.
      # @return [Peddler::Response] The API response
      def get_invoice_headers(marketplace_id, next_token: nil, from_issue_date: nil, to_issue_date: nil,
        invoices_modified_after: nil)
        path = "/finances/invoices/2026-06-25/invoices"
        params = {
          "nextToken" => next_token,
          "marketplaceId" => marketplace_id,
          "fromIssueDate" => from_issue_date,
          "toIssueDate" => to_issue_date,
          "invoicesModifiedAfter" => invoices_modified_after,
        }.compact
        parser = -> { GetInvoicesResponse }
        get(path, params:, parser:)
      end

      # Returns invoice details, including header and line items, for the specified invoice.
      #
      # @note This operation can make a static sandbox call.
      # @param marketplace_id [String] The marketplace ID of the marketplace of the invoice. The marketplace ID is a
      #   globally unique identifier used to specify an Amazon marketplace. For more information, refer to [Marketplace
      #   IDs](https://developer-docs.amazon.com/sp-api/docs/marketplace-ids).
      # @param invoice_identifier [String] The unique identifier for an invoice. This field is also returned as part of
      #   the `InvoiceHeader` element in the response. For AP-Inventory invoices the identifier is formatted as
      #   `InvoiceNumber~PayeeCode`.
      # @param next_token_for_line_items [String] The response includes `nextTokenForLineItems` when the number of line
      #   items exceeds the default page size (600). To get the next page of line items, call the operation with this
      #   token, including the same request parameters as the call that generated the token.
      # @return [Peddler::Response] The API response
      def get_invoice(marketplace_id, invoice_identifier, next_token_for_line_items: nil)
        path = "/finances/invoices/2026-06-25/invoices/#{percent_encode(invoice_identifier)}"
        params = {
          "marketplaceId" => marketplace_id,
          "nextTokenForLineItems" => next_token_for_line_items,
        }.compact
        parser = -> { GetInvoiceResponse }
        get(path, params:, parser:)
      end
    end
  end
end
