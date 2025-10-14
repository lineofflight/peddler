# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # An item of a debt payment or debt adjustment.
      DebtRecoveryItem = Structure.new do
        # @return [String] The beginning date and time of the financial event group that contains the debt. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute?(:group_begin_date, String, from: "GroupBeginDate")

        # @return [String] The ending date and time of the financial event group that contains the debt. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute?(:group_end_date, String, from: "GroupEndDate")

        # @return [Money] The original debt amount.
        attribute?(:original_amount, Money, from: "OriginalAmount")

        # @return [Money] The amount applied for the recovery item.
        attribute?(:recovery_amount, Money, from: "RecoveryAmount")
      end
    end
  end
end
