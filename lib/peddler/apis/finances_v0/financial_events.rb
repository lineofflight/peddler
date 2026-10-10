# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FinancesV0
      # All the information that is related to a financial event.
      FinancialEvents = Structure.new do
        attribute?(:adhoc_disbursement_event_list, [AdhocDisbursementEvent], from: "AdhocDisbursementEventList")

        attribute?(:adjustment_event_list, [AdjustmentEvent], from: "AdjustmentEventList")

        attribute?(:affordability_expense_event_list, [AffordabilityExpenseEvent], from: "AffordabilityExpenseEventList")

        attribute?(:affordability_expense_reversal_event_list, [AffordabilityExpenseEvent], from: "AffordabilityExpenseReversalEventList")

        attribute?(:capacity_reservation_billing_event_list, [CapacityReservationBillingEvent], from: "CapacityReservationBillingEventList")

        attribute?(:charge_refund_event_list, [ChargeRefundEvent], from: "ChargeRefundEventList")

        # A list of chargeback events.
        attribute?(:chargeback_event_list, [ShipmentEvent], from: "ChargebackEventList")

        attribute?(:coupon_payment_event_list, [CouponPaymentEvent], from: "CouponPaymentEventList")

        attribute?(:debt_recovery_event_list, [DebtRecoveryEvent], from: "DebtRecoveryEventList")

        # A list of EBT refund reimbursement events.
        attribute?(:ebt_refund_reimbursement_only_event_list, [EBTRefundReimbursementOnlyEvent], from: "EBTRefundReimbursementOnlyEventList")

        attribute?(:fba_liquidation_event_list, [FBALiquidationEvent], from: "FBALiquidationEventList")

        attribute?(:failed_adhoc_disbursement_event_list, [FailedAdhocDisbursementEvent], from: "FailedAdhocDisbursementEventList")

        # A list of guarantee claim events.
        attribute?(:guarantee_claim_event_list, [ShipmentEvent], from: "GuaranteeClaimEventList")

        attribute?(:imaging_services_fee_event_list, [ImagingServicesFeeEvent], from: "ImagingServicesFeeEventList")

        attribute?(:loan_servicing_event_list, [LoanServicingEvent], from: "LoanServicingEventList")

        attribute?(:network_commingling_transaction_event_list, [NetworkComminglingTransactionEvent], from: "NetworkComminglingTransactionEventList")

        attribute?(:pay_with_amazon_event_list, [PayWithAmazonEvent], from: "PayWithAmazonEventList")

        attribute?(:product_ads_payment_event_list, [ProductAdsPaymentEvent], from: "ProductAdsPaymentEventList")

        # A list of refund events.
        attribute?(:refund_event_list, [ShipmentEvent], from: "RefundEventList")

        attribute?(:removal_shipment_adjustment_event_list, [RemovalShipmentAdjustmentEvent], from: "RemovalShipmentAdjustmentEventList")

        attribute?(:removal_shipment_event_list, [RemovalShipmentEvent], from: "RemovalShipmentEventList")

        attribute?(:rental_transaction_event_list, [RentalTransactionEvent], from: "RentalTransactionEventList")

        attribute?(:retrocharge_event_list, [RetrochargeEvent], from: "RetrochargeEventList")

        attribute?(:safet_reimbursement_event_list, [SAFETReimbursementEvent], from: "SAFETReimbursementEventList")

        attribute?(:seller_deal_payment_event_list, [SellerDealPaymentEvent], from: "SellerDealPaymentEventList")

        attribute?(:seller_review_enrollment_payment_event_list, [SellerReviewEnrollmentPaymentEvent], from: "SellerReviewEnrollmentPaymentEventList")

        attribute?(:service_fee_event_list, [ServiceFeeEvent], from: "ServiceFeeEventList")

        attribute?(:service_provider_credit_event_list, [SolutionProviderCreditEvent], from: "ServiceProviderCreditEventList")

        # A list of shipment events.
        attribute?(:shipment_event_list, [ShipmentEvent], from: "ShipmentEventList")

        # A list of Shipment Settle events.
        attribute?(:shipment_settle_event_list, [ShipmentEvent], from: "ShipmentSettleEventList")

        attribute?(:tds_reimbursement_event_list, [TDSReimbursementEvent], from: "TDSReimbursementEventList")

        attribute?(:tax_withholding_event_list, [TaxWithholdingEvent], from: "TaxWithholdingEventList")

        attribute?(:trial_shipment_event_list, [TrialShipmentEvent], from: "TrialShipmentEventList")

        attribute?(:value_added_service_charge_event_list, [ValueAddedServiceChargeEvent], from: "ValueAddedServiceChargeEventList")
      end
    end
  end
end
