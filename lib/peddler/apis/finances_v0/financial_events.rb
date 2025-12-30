# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesV0
      # All the information that is related to a financial event.
      FinancialEvents = Structure.new do
        # @return [Array<AdhocDisbursementEvent>]
        attribute?(:adhoc_disbursement_event_list, [AdhocDisbursementEvent], from: "AdhocDisbursementEventList")

        # @return [Array<AdjustmentEvent>]
        attribute?(:adjustment_event_list, [AdjustmentEvent], from: "AdjustmentEventList")

        # @return [Array<AffordabilityExpenseEvent>]
        attribute?(:affordability_expense_event_list, [AffordabilityExpenseEvent], from: "AffordabilityExpenseEventList")

        # @return [Array<AffordabilityExpenseEvent>]
        attribute?(:affordability_expense_reversal_event_list, [AffordabilityExpenseEvent], from: "AffordabilityExpenseReversalEventList")

        # @return [Array<CapacityReservationBillingEvent>]
        attribute?(:capacity_reservation_billing_event_list, [CapacityReservationBillingEvent], from: "CapacityReservationBillingEventList")

        # @return [Array<ChargeRefundEvent>]
        attribute?(:charge_refund_event_list, [ChargeRefundEvent], from: "ChargeRefundEventList")

        # @return [Array<ShipmentEvent>] A list of chargeback events.
        attribute?(:chargeback_event_list, [ShipmentEvent], from: "ChargebackEventList")

        # @return [Array<CouponPaymentEvent>]
        attribute?(:coupon_payment_event_list, [CouponPaymentEvent], from: "CouponPaymentEventList")

        # @return [Array<DebtRecoveryEvent>]
        attribute?(:debt_recovery_event_list, [DebtRecoveryEvent], from: "DebtRecoveryEventList")

        # @return [Array<EBTRefundReimbursementOnlyEvent>] A list of EBT refund reimbursement events.
        attribute?(:ebt_refund_reimbursement_only_event_list, [EBTRefundReimbursementOnlyEvent], from: "EBTRefundReimbursementOnlyEventList")

        # @return [Array<FBALiquidationEvent>]
        attribute?(:fba_liquidation_event_list, [FBALiquidationEvent], from: "FBALiquidationEventList")

        # @return [Array<FailedAdhocDisbursementEvent>]
        attribute?(:failed_adhoc_disbursement_event_list, [FailedAdhocDisbursementEvent], from: "FailedAdhocDisbursementEventList")

        # @return [Array<ShipmentEvent>] A list of guarantee claim events.
        attribute?(:guarantee_claim_event_list, [ShipmentEvent], from: "GuaranteeClaimEventList")

        # @return [Array<ImagingServicesFeeEvent>]
        attribute?(:imaging_services_fee_event_list, [ImagingServicesFeeEvent], from: "ImagingServicesFeeEventList")

        # @return [Array<LoanServicingEvent>]
        attribute?(:loan_servicing_event_list, [LoanServicingEvent], from: "LoanServicingEventList")

        # @return [Array<NetworkComminglingTransactionEvent>]
        attribute?(:network_commingling_transaction_event_list, [NetworkComminglingTransactionEvent], from: "NetworkComminglingTransactionEventList")

        # @return [Array<PayWithAmazonEvent>]
        attribute?(:pay_with_amazon_event_list, [PayWithAmazonEvent], from: "PayWithAmazonEventList")

        # @return [Array<ProductAdsPaymentEvent>]
        attribute?(:product_ads_payment_event_list, [ProductAdsPaymentEvent], from: "ProductAdsPaymentEventList")

        # @return [Array<ShipmentEvent>] A list of refund events.
        attribute?(:refund_event_list, [ShipmentEvent], from: "RefundEventList")

        # @return [Array<RemovalShipmentAdjustmentEvent>]
        attribute?(:removal_shipment_adjustment_event_list, [RemovalShipmentAdjustmentEvent], from: "RemovalShipmentAdjustmentEventList")

        # @return [Array<RemovalShipmentEvent>]
        attribute?(:removal_shipment_event_list, [RemovalShipmentEvent], from: "RemovalShipmentEventList")

        # @return [Array<RentalTransactionEvent>]
        attribute?(:rental_transaction_event_list, [RentalTransactionEvent], from: "RentalTransactionEventList")

        # @return [Array<RetrochargeEvent>]
        attribute?(:retrocharge_event_list, [RetrochargeEvent], from: "RetrochargeEventList")

        # @return [Array<SAFETReimbursementEvent>]
        attribute?(:safet_reimbursement_event_list, [SAFETReimbursementEvent], from: "SAFETReimbursementEventList")

        # @return [Array<SellerDealPaymentEvent>]
        attribute?(:seller_deal_payment_event_list, [SellerDealPaymentEvent], from: "SellerDealPaymentEventList")

        # @return [Array<SellerReviewEnrollmentPaymentEvent>]
        attribute?(:seller_review_enrollment_payment_event_list, [SellerReviewEnrollmentPaymentEvent], from: "SellerReviewEnrollmentPaymentEventList")

        # @return [Array<ServiceFeeEvent>]
        attribute?(:service_fee_event_list, [ServiceFeeEvent], from: "ServiceFeeEventList")

        # @return [Array<SolutionProviderCreditEvent>]
        attribute?(:service_provider_credit_event_list, [SolutionProviderCreditEvent], from: "ServiceProviderCreditEventList")

        # @return [Array<ShipmentEvent>] A list of shipment events.
        attribute?(:shipment_event_list, [ShipmentEvent], from: "ShipmentEventList")

        # @return [Array<ShipmentEvent>] A list of Shipment Settle events.
        attribute?(:shipment_settle_event_list, [ShipmentEvent], from: "ShipmentSettleEventList")

        # @return [Array<TDSReimbursementEvent>]
        attribute?(:tds_reimbursement_event_list, [TDSReimbursementEvent], from: "TDSReimbursementEventList")

        # @return [Array<TaxWithholdingEvent>]
        attribute?(:tax_withholding_event_list, [TaxWithholdingEvent], from: "TaxWithholdingEventList")

        # @return [Array<TrialShipmentEvent>]
        attribute?(:trial_shipment_event_list, [TrialShipmentEvent], from: "TrialShipmentEventList")

        # @return [Array<ValueAddedServiceChargeEvent>]
        attribute?(:value_added_service_charge_event_list, [ValueAddedServiceChargeEvent], from: "ValueAddedServiceChargeEventList")
      end
    end
  end
end
