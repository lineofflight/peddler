# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # An event related to a rental transaction.
      RentalTransactionEvent = Structure.new do
        # @return [String] An Amazon-defined identifier for an order.
        attribute?(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [Integer] The number of days that the buyer extended an already rented item. This value is only
        #   returned for `RentalCustomerPayment-Extension` and `RentalCustomerRefund-Extension` events.
        attribute?(:extension_length, Integer, from: "ExtensionLength")

        # @return [String] The name of the marketplace.
        attribute?(:marketplace_name, String, from: "MarketplaceName")

        # @return [String] The date and time when the financial event was posted.
        attribute?(:posted_date, String, from: "PostedDate")

        # @return [Array<ChargeComponent>] A list of charges associated with the rental event.
        attribute?(:rental_charge_list, [ChargeComponent], from: "RentalChargeList")

        # @return [String] The type of rental event.
        #
        # Possible values:
        #
        # * `RentalCustomerPayment-Buyout`: A transaction type that represents when the customer wants to buy out a
        #   rented item.
        #
        # * `RentalCustomerPayment-Extension`: A transaction type that represents when the customer wants to extend the
        #   rental period.
        #
        # * `RentalCustomerRefund-Buyout`: A transaction type that represents when the customer requests a refund for
        #   the buyout of the rented item.
        #
        # * `RentalCustomerRefund-Extension`: A transaction type that represents when the customer requests a refund
        #   over the extension on the rented item.
        #
        # * `RentalHandlingFee`: A transaction type that represents the fee that Amazon charges sellers who rent through
        #   Amazon.
        #
        # * `RentalChargeFailureReimbursement`: A transaction type that represents when Amazon sends money to the seller
        #   to compensate for a failed charge.
        #
        # * `RentalLostItemReimbursement`: A transaction type that represents when Amazon sends money to the seller to
        #   compensate for a lost item.
        attribute?(:rental_event_type, String, from: "RentalEventType")

        # @return [Array<FeeComponent>] A list of fees associated with the rental event.
        attribute?(:rental_fee_list, [FeeComponent], from: "RentalFeeList")

        # @return [Money] The amount of money that the customer originally paid to rent the item. This value is only
        #   returned for `RentalChargeFailureReimbursement` and `RentalLostItemReimbursement` events.
        attribute?(:rental_initial_value, Money, from: "RentalInitialValue")

        # @return [Money] The amount of money that Amazon sends the seller to compensate for a lost item or a failed
        #   charge. This value is only returned for `RentalChargeFailureReimbursement` and `RentalLostItemReimbursement`
        #   events.
        attribute?(:rental_reimbursement, Money, from: "RentalReimbursement")

        # @return [Array<TaxWithheldComponent>] A list of taxes withheld information for a rental item.
        attribute?(:rental_tax_withheld_list, [TaxWithheldComponent], from: "RentalTaxWithheldList")
      end
    end
  end
end
