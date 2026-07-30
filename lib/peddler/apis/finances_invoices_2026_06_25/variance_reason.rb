# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FinancesInvoices20260625
      # The type and underlying defect classifications explaining discrepancies between expected and actual invoice
      # values.
      VarianceReason = Structure.new do
        # @return [String] The type of variance.
        attribute(:variance_type, String, null: false, from: "varianceType")

        # @return [Array<String>] List of defect types associated with the variance. These represent root cause
        #   classifications for the variance.
        #
        # **Possible values for PPV (Purchase Price Variance):**
        #
        # * `DEALBUY`: Amazon raised discounted POs at vendor-accepted discount costs, but the vendor invoiced at
        #   regular costs.
        # * `PRODUCT_COST_NOT_ACTIVE`: Vendor is using a cost that is not currently active; it may be pending approval
        #   or is a historical cost.
        # * `PRODUCT_COST_NOT_REGISTERED`: Vendor is using a cost that is not registered in Amazon's system, often due
        #   to offline negotiations not yet updated.
        # * `VENDOR_LOWERING_COST_AT_PO_CONFIRMATION`: Vendor confirmed the PO at a lower cost but invoiced at a
        #   different (higher) amount.
        # * `CCOGS_PRICE_PROTECTION_AGREEMENT_PPA`: A Price Protection clause in the vendor's Terms and Conditions
        #   agreement applies to this ASIN.
        # * `FALSE_CCOGS_PPA`: Invoiced cost exceeded the confirmed PO cost due to a cost price adjustment by Amazon,
        #   likely from a previous cost decrease within the same period.
        # * `AMAZON_POC_LOWERING_COST_ON_PO`: Amazon's systems reduced the cost price for this ASIN post PO
        #   confirmation, most likely due to a previous cost price decrease or on request.
        # * `REJECTED_PRICE_INCREASE_ON_PO`: Vendor submitted a cost price increase that was denied, but still invoiced
        #   at the increased cost.
        # * `LIST_PRICE_DISCOUNT_ISSUES`: The List Price on the PO and invoice do not match, or the Discount code on the
        #   PO does not match the invoice.
        # * `ROUNDING_ISSUES`: Price variance caused by foreign exchange currency conversion or decimal place rounding
        #   differences.
        # * `OTHER`: Defect type not belonging to a predefined category.
        #
        # **Possible values for PQV (Purchase Quantity Variance):**
        #
        # * `UNRECOGNISED_ASIN`: The ASIN on the invoice is not recognized or does not match Amazon's records.
        # * `OVERBILLING`: The invoiced quantity exceeds the quantity received or expected by Amazon.
        # * `DUPLICATE_INVOICE_DEFECT`: The invoice is a duplicate of a previously submitted invoice.
        # * `DELETED_APPOINTMENT`: The delivery appointment associated with this shipment was deleted.
        # * `NO_APPOINTMENT`: No delivery appointment was found for this shipment.
        # * `SHORTAGES_IN_TRANSIT`: Quantity shortages detected during transit — fewer units arrived than were shipped.
        # * `ASIN_MISMATCH`: Amazon's systems received an ASIN with a different cost than the one ordered on the PO,
        #   possibly due to incorrect smart-matching or cross-matching.
        # * `FEED_DEFECTS`: Vendor's price feed contains defects such as unrecognized UPC/EAN codes or incorrect
        #   supplier IDs for multi-supplier updates.
        # * `REJECTED_LINE_ITEM_ON_PO`: Vendor confirmed this PO line item as Rejected or On-hold but still shipped the
        #   products.
        # * `FAILED_PO_CONFIRMATION`: Vendor's latest PO confirmation message for this line item failed processing and
        #   was not translated correctly.
        # * `OTHER`: Defect type not belonging to a predefined category.
        attribute?(:defect_types, [String], from: "defectTypes")
      end
    end
  end
end
