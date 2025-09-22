# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"

module Peddler
  module Types
    module FinancesV0
      # Information related to a financial event group.
      FinancialEventGroup = Structure.new do
        # @return [String] A unique identifier for the financial event group.
        attribute(:financial_event_group_id, String, from: "FinancialEventGroupId")

        # @return [String] The processing status of the financial event group indicates whether the balance of the
        # financial event group is settled.
        #
        # Possible values:
        #
        # * Open
        #
        # * Closed
        attribute(:processing_status, String, from: "ProcessingStatus")

        # @return [String] The status of the fund transfer.
        attribute(:fund_transfer_status, String, from: "FundTransferStatus")

        # @return [Money] The total amount in the currency of the marketplace in which the transactions occurred. For a
        # closed financial group, this is the total amount of a disbursement or a charge amount. For an open financial
        # event group, this is the current balance.
        attribute(:original_total, Money, from: "OriginalTotal")

        # @return [Money] The total amount in the currency of the marketplace in which the funds were disbursed.
        attribute(:converted_total, Money, from: "ConvertedTotal")

        # @return [String] The date and time when the disbursement or charge was initiated. Only present for closed
        # settlements. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute(:fund_transfer_date, String, from: "FundTransferDate")

        # @return [String] The trace identifier used by sellers to look up transactions externally.
        attribute(:trace_id, String, from: "TraceId")

        # @return [String] The account tail of the payment instrument.
        attribute(:account_tail, String, from: "AccountTail")

        # @return [Money] The balance at the beginning of the settlement period.
        attribute(:beginning_balance, Money, from: "BeginningBalance")

        # @return [String] The date and time at which the financial event group is opened. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute(:financial_event_group_start, String, from: "FinancialEventGroupStart")

        # @return [String] The date and time at which the financial event group is closed. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute(:financial_event_group_end, String, from: "FinancialEventGroupEnd")
      end
    end
  end
end
