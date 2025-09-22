# frozen_string_literal: true

require "peddler/types/money"
require "peddler/types/orders_v0/payment_execution_detail_item"
require "peddler/types/orders_v0/address"
require "peddler/types/orders_v0/buyer_tax_information"
require "peddler/types/orders_v0/fulfillment_instruction"
require "peddler/types/orders_v0/marketplace_tax_info"
require "peddler/types/orders_v0/buyer_info"
require "peddler/types/orders_v0/automated_shipping_settings"

module Peddler
  module Types
    module OrdersV0
      # Order information.
      Order = Structure.new do
        # @return [String] An Amazon-defined order identifier, in 3-7-7 format.
        attribute(:amazon_order_id, String, from: "AmazonOrderId")

        # @return [String] A seller-defined order identifier.
        attribute(:seller_order_id, String, from: "SellerOrderId")

        # @return [String] The date when the order was created.
        attribute(:purchase_date, String, from: "PurchaseDate")

        # @return [String] The date when the order was last updated.
        #
        # __Note__: `LastUpdateDate` is returned with an incorrect date for orders that were last updated before
        # 2009-04-01.
        attribute(:last_update_date, String, from: "LastUpdateDate")

        # @return [String] The current order status.
        attribute(:order_status, String, from: "OrderStatus")

        # @return [String] Whether the order was fulfilled by Amazon (`AFN`) or by the seller (`MFN`).
        attribute(:fulfillment_channel, String, from: "FulfillmentChannel")

        # @return [String] The sales channel for the first item in the order.
        attribute(:sales_channel, String, from: "SalesChannel")

        # @return [String] The order channel for the first item in the order.
        attribute(:order_channel, String, from: "OrderChannel")

        # @return [String] The order's shipment service level.
        attribute(:ship_service_level, String, from: "ShipServiceLevel")

        # @return [Types::Money] The total charge for this order.
        attribute(:order_total, Types::Money, from: "OrderTotal")

        # @return [Integer] The number of items shipped.
        attribute(:number_of_items_shipped, Integer, from: "NumberOfItemsShipped")

        # @return [Integer] The number of items unshipped.
        attribute(:number_of_items_unshipped, Integer, from: "NumberOfItemsUnshipped")

        # @return [Array<PaymentExecutionDetailItem>] Information about the sub-payment methods for an order.
        attribute(:payment_execution_detail, [PaymentExecutionDetailItem], from: "PaymentExecutionDetail")

        # @return [String] The payment method for the order. This property is limited to COD and CVS payment methods.
        # Unless you need the specific COD payment information provided by the `PaymentExecutionDetailItem` object, we
        # recommend using the `PaymentMethodDetails` property to get payment method information.
        attribute(:payment_method, String, from: "PaymentMethod")

        # @return [Array] A list of payment methods for the order.
        attribute(:payment_method_details, Array, from: "PaymentMethodDetails")

        # @return [String] The identifier for the marketplace where the order was placed.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The shipment service level category for the order.
        #
        # **Possible values**: `Expedited`, `FreeEconomy`, `NextDay`, `Priority`, `SameDay`, `SecondDay`, `Scheduled`,
        # and `Standard`.
        attribute(:shipment_service_level_category, String, from: "ShipmentServiceLevelCategory")

        # @return [String] The status of the Amazon Easy Ship order. This property is only included for Amazon Easy Ship
        # orders.
        attribute(:easy_ship_shipment_status, String, from: "EasyShipShipmentStatus")

        # @return [String] Custom ship label for Checkout by Amazon (CBA).
        attribute(:cba_displayable_shipping_label, String, from: "CbaDisplayableShippingLabel")

        # @return [String] The order's type.
        attribute(:order_type, String, from: "OrderType")

        # @return [String] The start of the time period within which you have committed to ship the order. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format. Only returned for
        # seller-fulfilled orders.
        #
        # __Note__: `EarliestShipDate` might not be returned for orders placed before February 1, 2013.
        attribute(:earliest_ship_date, String, from: "EarliestShipDate")

        # @return [String] The end of the time period within which you have committed to ship the order. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format. Only returned for
        # seller-fulfilled orders.
        #
        # __Note__: `LatestShipDate` might not be returned for orders placed before February 1, 2013.
        attribute(:latest_ship_date, String, from: "LatestShipDate")

        # @return [String] The start of the time period within which you have committed to fulfill the order. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format. Only returned for
        # seller-fulfilled orders.
        attribute(:earliest_delivery_date, String, from: "EarliestDeliveryDate")

        # @return [String] The end of the time period within which you have committed to fulfill the order. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format. Only returned for
        # seller-fulfilled orders that do not have a `PendingAvailability`, `Pending`, or `Canceled` status.
        attribute(:latest_delivery_date, String, from: "LatestDeliveryDate")

        # @return [:boolean] When true, the order is an Amazon Business order. An Amazon Business order is an order
        # where the buyer is a Verified Business Buyer.
        attribute(:business_order, :boolean, from: "IsBusinessOrder")

        # @return [:boolean] When true, the order is a seller-fulfilled Amazon Prime order.
        attribute(:prime, :boolean, from: "IsPrime")

        # @return [:boolean] When true, the order has a Premium Shipping Service Level Agreement. For more information
        # about Premium Shipping orders, refer to "Premium Shipping Options" in the Seller Central Help for your
        # marketplace.
        attribute(:premium_order, :boolean, from: "IsPremiumOrder")

        # @return [:boolean] When true, the order is a `GlobalExpress` order.
        attribute(:global_express_enabled, :boolean, from: "IsGlobalExpressEnabled")

        # @return [String] The order ID value for the order that is being replaced. Returned only if IsReplacementOrder
        # = true.
        attribute(:replaced_order_id, String, from: "ReplacedOrderId")

        # @return [:boolean] When true, this is a replacement order.
        attribute(:replacement_order, :boolean, from: "IsReplacementOrder")

        # @return [String] Indicates the date by which the seller must respond to the buyer with an estimated ship date.
        # Only returned for Sourcing on Demand orders.
        attribute(:promise_response_due_date, String, from: "PromiseResponseDueDate")

        # @return [:boolean] When true, the estimated ship date is set for the order. Only returned for Sourcing on
        # Demand orders.
        attribute(:estimated_ship_date_set, :boolean, from: "IsEstimatedShipDateSet")

        # @return [:boolean] When true, the item within this order was bought and re-sold by Amazon Business EU SARL
        # (ABEU). By buying and instantly re-selling your items, ABEU becomes the seller of record, making your
        # inventory available for sale to customers who would not otherwise purchase from a third-party seller.
        attribute(:sold_by_ab, :boolean, from: "IsSoldByAB")

        # @return [:boolean] When true, the item within this order was bought and re-sold by Amazon Business EU SARL
        # (ABEU). By buying and instantly re-selling your items, ABEU becomes the seller of record, making your
        # inventory available for sale to customers who would not otherwise purchase from a third-party seller.
        attribute(:iba, :boolean, from: "IsIBA")

        # @return [Address] The recommended location for the seller to ship the items from. It is calculated at
        # checkout. The seller may or may not choose to ship from this location.
        attribute(:default_ship_from_location_address, Address, from: "DefaultShipFromLocationAddress")

        # @return [String] The buyer's invoicing preference. Sellers can use this data to issue electronic invoices for
        # orders in Turkey.
        #
        # **Note**: This attribute is only available in the Turkey marketplace.
        attribute(:buyer_invoice_preference, String, from: "BuyerInvoicePreference")

        # @return [BuyerTaxInformation] Contains the business invoice tax information. Sellers could use this data to
        # issue electronic invoices for business orders in Turkey.
        #
        # **Note**:
        # 1. This attribute is only available in the Turkey marketplace for the orders that `BuyerInvoicePreference` is
        # BUSINESS.
        # 2. The `BuyerTaxInformation` is a restricted data. Use the Restricted Data Token (RDT) and restricted SPDS
        # roles to access this restricted data.
        attribute(:buyer_tax_information, BuyerTaxInformation, from: "BuyerTaxInformation")

        # @return [FulfillmentInstruction] Contains the instructions about the fulfillment, such as the location from
        # where you want the order filled.
        attribute(:fulfillment_instruction, FulfillmentInstruction, from: "FulfillmentInstruction")

        # @return [:boolean] When true, this order is marked to be picked up from a store rather than delivered.
        attribute(:ispu, :boolean, from: "IsISPU")

        # @return [:boolean] When true, this order is marked to be delivered to an Access Point. The access location is
        # chosen by the customer. Access Points include Amazon Hub Lockers, Amazon Hub Counters, and pickup points
        # operated by carriers.
        attribute(:access_point_order, :boolean, from: "IsAccessPointOrder")

        # @return [MarketplaceTaxInfo] Tax information about the marketplace where the sale took place. Sellers can use
        # this data to issue electronic invoices for orders in Brazil.
        #
        # **Note**: This attribute is only available in the Brazil marketplace for the orders with `Pending` or
        # `Unshipped` status.
        attribute(:marketplace_tax_info, MarketplaceTaxInfo, from: "MarketplaceTaxInfo")

        # @return [String] The seller’s friendly name registered in the marketplace where the sale took place. Sellers
        # can use this data to issue electronic invoices for orders in Brazil.
        #
        # **Note**: This attribute is only available in the Brazil marketplace for the orders with `Pending` or
        # `Unshipped` status.
        attribute(:seller_display_name, String, from: "SellerDisplayName")

        # @return [Address] The shipping address for the order.
        #
        # **Note**:
        # 1. `ShippingAddress` is only available for orders with the following status values: Unshipped,
        # `PartiallyShipped`, Shipped and `InvoiceUnconfirmed`.
        # 2. The `ShippingAddress` contains restricted data. Use the Restricted Data Token (RDT) and restricted SPDS
        # roles to access the restricted data in `ShippingAddress`. For example, `Name`, `AddressLine1`, `AddressLine2`,
        # `AddressLine3`, `Phone`, `AddressType`, and `ExtendedFields`.
        attribute(:shipping_address, Address, from: "ShippingAddress")

        # @return [BuyerInfo] Buyer information.
        #
        # **Note**: The `BuyerInfo` contains restricted data. Use the Restricted Data Token (RDT) and restricted SPDS
        # roles to access the restricted data in `BuyerInfo`. For example, `BuyerName`, `BuyerTaxInfo`, and
        # `PurchaseOrderNumber`.
        attribute(:buyer_info, BuyerInfo, from: "BuyerInfo")

        # @return [AutomatedShippingSettings] Contains information regarding the Shipping Settings Automaton program,
        # such as whether the order's shipping settings were generated automatically, and what those settings are.
        attribute(:automated_shipping_settings, AutomatedShippingSettings, from: "AutomatedShippingSettings")

        # @return [:boolean] Whether the order contains regulated items which may require additional approval steps
        # before being fulfilled.
        attribute(:has_regulated_items, :boolean, from: "HasRegulatedItems")

        # @return [String] The status of the electronic invoice.
        attribute(:electronic_invoice_status, String, from: "ElectronicInvoiceStatus")
      end
    end
  end
end
