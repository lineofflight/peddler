# frozen_string_literal: true

require "peddler/types/finances_v0/currency"

module Peddler
  module Types
    module FinancesV0
      # An item of a debt payment or debt adjustment.
      DebtRecoveryItem = Structure.new do
        # @return [Currency] The amount applied for the recovery item.
        attribute(:recovery_amount, Currency, from: "RecoveryAmount")

        # @return [Currency] The original debt amount.
        attribute(:original_amount, Currency, from: "OriginalAmount")

        # @return [String] The beginning date and time of the financial event group that contains the debt. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute(:group_begin_date, String, from: "GroupBeginDate")

        # @return [String] The ending date and time of the financial event group that contains the debt. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute(:group_end_date, String, from: "GroupEndDate")
      end
    end
  end
end
