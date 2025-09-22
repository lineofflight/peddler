# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/finances_v0/shipment_event"
require "peddler/types/finances_v0/pay_with_amazon_event"
require "peddler/types/finances_v0/solution_provider_credit_event"
require "peddler/types/finances_v0/retrocharge_event"
require "peddler/types/finances_v0/rental_transaction_event"
require "peddler/types/finances_v0/product_ads_payment_event"
require "peddler/types/finances_v0/service_fee_event"
require "peddler/types/finances_v0/seller_deal_payment_event"
require "peddler/types/finances_v0/debt_recovery_event"
require "peddler/types/finances_v0/loan_servicing_event"
require "peddler/types/finances_v0/adjustment_event"
require "peddler/types/finances_v0/safet_reimbursement_event"
require "peddler/types/finances_v0/seller_review_enrollment_payment_event"
require "peddler/types/finances_v0/fba_liquidation_event"
require "peddler/types/finances_v0/coupon_payment_event"
require "peddler/types/finances_v0/imaging_services_fee_event"
require "peddler/types/finances_v0/network_commingling_transaction_event"
require "peddler/types/finances_v0/affordability_expense_event"
require "peddler/types/finances_v0/removal_shipment_event"
require "peddler/types/finances_v0/removal_shipment_adjustment_event"
require "peddler/types/finances_v0/trial_shipment_event"
require "peddler/types/finances_v0/tds_reimbursement_event"
require "peddler/types/finances_v0/adhoc_disbursement_event"
require "peddler/types/finances_v0/tax_withholding_event"
require "peddler/types/finances_v0/charge_refund_event"
require "peddler/types/finances_v0/failed_adhoc_disbursement_event"
require "peddler/types/finances_v0/value_added_service_charge_event"
require "peddler/types/finances_v0/capacity_reservation_billing_event"

module Peddler
  module Types
    module FinancesV0
      # Contains all information related to a financial event.
      FinancialEvents = Structure.new do
        # @return [Array<ShipmentEvent>] A list of shipment events.
        attribute(:shipment_event_list, [ShipmentEvent], from: "ShipmentEventList")

        # @return [Array<ShipmentEvent>] A list of Shipment Settle events.
        attribute(:shipment_settle_event_list, [ShipmentEvent], from: "ShipmentSettleEventList")

        # @return [Array<ShipmentEvent>] A list of refund events.
        attribute(:refund_event_list, [ShipmentEvent], from: "RefundEventList")

        # @return [Array<ShipmentEvent>] A list of guarantee claim events.
        attribute(:guarantee_claim_event_list, [ShipmentEvent], from: "GuaranteeClaimEventList")

        # @return [Array<ShipmentEvent>] A list of chargeback events.
        attribute(:chargeback_event_list, [ShipmentEvent], from: "ChargebackEventList")

        # @return [Array<PayWithAmazonEvent>]
        attribute(:pay_with_amazon_event_list, [PayWithAmazonEvent], from: "PayWithAmazonEventList")

        # @return [Array<SolutionProviderCreditEvent>]
        attribute(:service_provider_credit_event_list, [SolutionProviderCreditEvent], from: "ServiceProviderCreditEventList")

        # @return [Array<RetrochargeEvent>]
        attribute(:retrocharge_event_list, [RetrochargeEvent], from: "RetrochargeEventList")

        # @return [Array<RentalTransactionEvent>]
        attribute(:rental_transaction_event_list, [RentalTransactionEvent], from: "RentalTransactionEventList")

        # @return [Array<ProductAdsPaymentEvent>]
        attribute(:product_ads_payment_event_list, [ProductAdsPaymentEvent], from: "ProductAdsPaymentEventList")

        # @return [Array<ServiceFeeEvent>]
        attribute(:service_fee_event_list, [ServiceFeeEvent], from: "ServiceFeeEventList")

        # @return [Array<SellerDealPaymentEvent>]
        attribute(:seller_deal_payment_event_list, [SellerDealPaymentEvent], from: "SellerDealPaymentEventList")

        # @return [Array<DebtRecoveryEvent>]
        attribute(:debt_recovery_event_list, [DebtRecoveryEvent], from: "DebtRecoveryEventList")

        # @return [Array<LoanServicingEvent>]
        attribute(:loan_servicing_event_list, [LoanServicingEvent], from: "LoanServicingEventList")

        # @return [Array<AdjustmentEvent>]
        attribute(:adjustment_event_list, [AdjustmentEvent], from: "AdjustmentEventList")

        # @return [Array<SAFETReimbursementEvent>]
        attribute(:safet_reimbursement_event_list, [SAFETReimbursementEvent], from: "SAFETReimbursementEventList")

        # @return [Array<SellerReviewEnrollmentPaymentEvent>]
        attribute(:seller_review_enrollment_payment_event_list, [SellerReviewEnrollmentPaymentEvent], from: "SellerReviewEnrollmentPaymentEventList")

        # @return [Array<FBALiquidationEvent>]
        attribute(:fba_liquidation_event_list, [FBALiquidationEvent], from: "FBALiquidationEventList")

        # @return [Array<CouponPaymentEvent>]
        attribute(:coupon_payment_event_list, [CouponPaymentEvent], from: "CouponPaymentEventList")

        # @return [Array<ImagingServicesFeeEvent>]
        attribute(:imaging_services_fee_event_list, [ImagingServicesFeeEvent], from: "ImagingServicesFeeEventList")

        # @return [Array<NetworkComminglingTransactionEvent>]
        attribute(:network_commingling_transaction_event_list, [NetworkComminglingTransactionEvent], from: "NetworkComminglingTransactionEventList")

        # @return [Array<AffordabilityExpenseEvent>]
        attribute(:affordability_expense_event_list, [AffordabilityExpenseEvent], from: "AffordabilityExpenseEventList")

        # @return [Array<AffordabilityExpenseEvent>]
        attribute(:affordability_expense_reversal_event_list, [AffordabilityExpenseEvent], from: "AffordabilityExpenseReversalEventList")

        # @return [Array<RemovalShipmentEvent>]
        attribute(:removal_shipment_event_list, [RemovalShipmentEvent], from: "RemovalShipmentEventList")

        # @return [Array<RemovalShipmentAdjustmentEvent>]
        attribute(:removal_shipment_adjustment_event_list, [RemovalShipmentAdjustmentEvent], from: "RemovalShipmentAdjustmentEventList")

        # @return [Array<TrialShipmentEvent>]
        attribute(:trial_shipment_event_list, [TrialShipmentEvent], from: "TrialShipmentEventList")

        # @return [Array<TDSReimbursementEvent>]
        attribute(:tds_reimbursement_event_list, [TDSReimbursementEvent], from: "TDSReimbursementEventList")

        # @return [Array<AdhocDisbursementEvent>]
        attribute(:adhoc_disbursement_event_list, [AdhocDisbursementEvent], from: "AdhocDisbursementEventList")

        # @return [Array<TaxWithholdingEvent>]
        attribute(:tax_withholding_event_list, [TaxWithholdingEvent], from: "TaxWithholdingEventList")

        # @return [Array<ChargeRefundEvent>]
        attribute(:charge_refund_event_list, [ChargeRefundEvent], from: "ChargeRefundEventList")

        # @return [Array<FailedAdhocDisbursementEvent>]
        attribute(:failed_adhoc_disbursement_event_list, [FailedAdhocDisbursementEvent], from: "FailedAdhocDisbursementEventList")

        # @return [Array<ValueAddedServiceChargeEvent>]
        attribute(:value_added_service_charge_event_list, [ValueAddedServiceChargeEvent], from: "ValueAddedServiceChargeEventList")

        # @return [Array<CapacityReservationBillingEvent>]
        attribute(:capacity_reservation_billing_event_list, [CapacityReservationBillingEvent], from: "CapacityReservationBillingEventList")
      end
    end
  end
end
