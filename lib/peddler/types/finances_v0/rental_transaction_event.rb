# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/finances_v0/charge_component"
require "peddler/types/finances_v0/fee_component"
require "peddler/types/finances_v0/tax_withheld_component"

module Peddler
  module Types
    module FinancesV0
      # An event related to a rental transaction.
      RentalTransactionEvent = Structure.new do
        # @return [String] An Amazon-defined identifier for an order.
        attribute?(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] The type of rental event.
        #
        # Possible values:
        #
        # * RentalCustomerPayment-Buyout - Transaction type that represents when the customer wants to buy out a rented
        # item.
        #
        # * RentalCustomerPayment-Extension - Transaction type that represents when the customer wants to extend the
        # rental period.
        #
        # * RentalCustomerRefund-Buyout - Transaction type that represents when the customer requests a refund for the
        # buyout of the rented item.
        #
        # * RentalCustomerRefund-Extension - Transaction type that represents when the customer requests a refund over
        # the extension on the rented item.
        #
        # * RentalHandlingFee - Transaction type that represents the fee that Amazon charges sellers who rent through
        # Amazon.
        #
        # * RentalChargeFailureReimbursement - Transaction type that represents when Amazon sends money to the seller to
        # compensate for a failed charge.
        #
        # * RentalLostItemReimbursement - Transaction type that represents when Amazon sends money to the seller to
        # compensate for a lost item.
        attribute?(:rental_event_type, String, from: "RentalEventType")

        # @return [Integer] The number of days that the buyer extended an already rented item. This value is only
        # returned for RentalCustomerPayment-Extension and RentalCustomerRefund-Extension events.
        attribute?(:extension_length, Integer, from: "ExtensionLength")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [Array<ChargeComponent>] A list of charges associated with the rental event.
        attribute?(:rental_charge_list, [ChargeComponent], from: "RentalChargeList")

        # @return [Array<FeeComponent>] A list of fees associated with the rental event.
        attribute?(:rental_fee_list, [FeeComponent], from: "RentalFeeList")

        # @return [String] The name of the marketplace.
        attribute?(:marketplace_name, String, from: "MarketplaceName")

        # @return [Money] The amount of money the customer originally paid to rent the item. This value is only returned
        # for RentalChargeFailureReimbursement and RentalLostItemReimbursement events.
        attribute?(:rental_initial_value, Money, from: "RentalInitialValue")

        # @return [Money] The amount of money Amazon sends the seller to compensate for a lost item or a failed charge.
        # This value is only returned for RentalChargeFailureReimbursement and RentalLostItemReimbursement events.
        attribute?(:rental_reimbursement, Money, from: "RentalReimbursement")

        # @return [Array<TaxWithheldComponent>] A list of taxes withheld information for a rental item.
        attribute?(:rental_tax_withheld_list, [TaxWithheldComponent], from: "RentalTaxWithheldList")
      end
    end
  end
end
