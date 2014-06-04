require 'peddler/client'

module MWS
  # The Off-Amazon Payments API helps you to process payments for purchases
  # made by buyers on your website using the Login and Pay with Amazon service.
  # This API enables you to programmatically retrieve shipping and payment
  # information provided by the buyer from their Amazon account. It allows you
  # to authorize, capture, and refund payments, enabling a variety of payments
  # scenarios.
  #
  # @note The Off-Amazon Payments API section is only applicable to payments
  #   made through the Login and Pay with Amazon service offered by Amazon
  #   Payments. You cannot use this API section to process payments for Amazon
  #   Marketplace, Amazon Webstore, or Checkout by Amazon.
  class OffAmazonPayments < ::Peddler::Client
    path '/OffAmazonPayments/2013-01-01/'

    # Sets order reference details such as the order total and a description for
    # the order
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_SetOrderReferenceDetails.html
    # @param amazon_order_reference_id [String]
    # @param order_total [Struct, Hash]
    # @param opts [Hash]
    # @option opts [String] :platform_id
    # @option opts [String] :seller_note
    # @option opts [Struct, Hash] :seller_order_attributes
    # @return [Peddler::XMLParser]
    def set_order_reference_details(amazon_order_reference_id, order_total, opts = {})
      operation('SetOrderReferenceDetails')
        .add(
          'AmazonOrderReferenceId' => amazon_order_reference_id,
          'OrderReferenceAttributes' => opts.merge('OrderTotal' => order_total)
        )

      run
    end

    # Returns details about the Order Reference object and its current state
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetOrderReferenceDetails.html
    # @param amazon_order_reference_id [String]
    # @param opts [Hash]
    # @option opts [String] address_consent_token
    # @return [Peddler::XMLParser]
    def get_order_reference_details(amazon_order_reference_id, opts = {})
      operation('GetOrderReferenceDetails')
        .add(opts.merge('AmazonOrderReferenceId' => amazon_order_reference_id))

      run
    end

    # Confirms that the order reference is free of constraints and all required
    # information has been set on the order reference
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_ConfirmOrderReference.html
    # @param amazon_order_reference_id [String]
    # @return [Peddler::XMLParser]
    def confirm_order_reference(amazon_order_reference_id)
      operation('ConfirmOrderReference')
        .add('AmazonOrderReferenceId' => amazon_order_reference_id)

      run
    end

    # Cancels a previously confirmed order reference
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_CancelOrderReference.html
    # @param amazon_order_reference_id [String]
    # @param opts [Hash]
    # @option opts [String] cancelation_reason
    # @return [Peddler::XMLParser]
    def cancel_order_reference(amazon_order_reference_id, opts = {})
      operation('CancelOrderReference')
        .add(opts.merge('AmazonOrderReferenceId' => amazon_order_reference_id))

      run
    end

    # Confirms that an order reference has been fulfilled (fully or partially)
    # and that you do not expect to create any new authorizations on this order
    # reference
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_CloseOrderReference.html
    # @param amazon_order_reference_id [String]
    # @param opts [Hash]
    # @option opts [String] closure_reason
    # @return [Peddler::XMLParser]
    def close_order_reference(amazon_order_reference_id, opts = {})
      operation('CloseOrderReference')
        .add(opts.merge('AmazonOrderReferenceId' => amazon_order_reference_id))

      run
    end

    # Reserves a specified amount against the payment method(s) stored in the
    # order reference
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_Authorize.html
    # @param amazon_order_reference_id [String]
    # @param authorization_reference_id [String]
    # @param authorization_amount [Struct, Hash]
    # @param opts [Hash]
    # @option opts [String] :seller_authorization_note
    # @option opts [Integer] :transaction_timeout
    # @option opts [Boolean] :capture_now
    # @option opts [String] :soft_descriptor
    # @return [Peddler::XMLParser]
    def authorize(amazon_order_reference_id, authorization_reference_id, authorization_amount, opts = {})
      operation('Authorize')
        .add(opts.merge(
          'AmazonOrderReferenceId' => amazon_order_reference_id,
          'AuthorizationReferenceId' => authorization_reference_id,
          'AuthorizationAmount' => authorization_amount
        ))

      run
    end

    # Returns the status of a particular authorization and the total amount
    # captured on the authorization
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetAuthorizationDetails.html
    # @param amazon_authorization_id [String]
    # @return [Peddler::XMLParser]
    def get_authorization_details(amazon_authorization_id)
      operation('GetAuthorizationDetails')
        .add('AmazonAuthorizationId' => amazon_authorization_id)

      run
    end

    # Captures funds from an authorized payment instrument
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_Capture.html
    # @param amazon_authorization_id [String]
    # @param capture_reference_id [String]
    # @param capture_amount [Struct, Hash]
    # @param opts [Hash]
    # @option opts [String] :seller_capture_note
    # @option opts [String] :soft_descriptor
    # @return [Peddler::XMLParser]
    def capture(amazon_authorization_id, capture_reference_id, capture_amount, opts = {})
      operation('Capture')
        .add(opts.merge(
          'AmazonAuthorizationId' => amazon_authorization_id,
          'CaptureReferenceId' => capture_reference_id,
          'CaptureAmount' => capture_amount
        ))

      run
    end

    # Returns the status of a particular capture and the total amount refunded
    # on the capture
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetCaptureDetails.html
    # @param amazon_capture_id [String]
    # @return [Peddler::XMLParser]
    def get_capture_details(amazon_capture_id)
      operation('GetAuthorizationDetails')
        .add('AmazonCaptureId' => amazon_capture_id)

      run
    end

    # Closes an authorization
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_CloseAuthorization.html
    # @param amazon_authorization_id [String]
    # @param opts [Hash]
    # @option opts [String] closure_reason
    # @return [Peddler::XMLParser]
    def close_authorization(amazon_authorization_id, opts = {})
      operation('CloseAuthorization')
        .add(opts.merge('AmazonAuthorizationId' => amazon_authorization_id))

      run
    end

    # Refunds a previously captured amount
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_Refund.html
    # @param amazon_capture_id [String]
    # @param refund_reference_id [String]
    # @param refund_amount [Struct, Hash]
    # @param opts [Hash]
    # @option opts [String] :seller_refund_note
    # @option opts [String] :soft_descriptor
    # @return [Peddler::XMLParser]
    def refund(amazon_capture_id, refund_reference_id, refund_amount, opts ={})
      operation('Refund')
        .add(opts.merge(
          'AmazonCaptureId' => amazon_capture_id,
          'RefundReferenceId' => refund_reference_id,
          'RefundAmount' => refund_amount
        ))

      run
    end

    # Returns the status of a particular refund
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetRefundDetails.html
    # @param amazon_refund_id [String]
    # @return [Peddler::XMLParser]
    def get_refund_details(amazon_refund_id)
      operation('GetRefundDetails')
        .add('AmazonRefundId' => 'amazon_refund_id')

      run
    end

    # Gets the operational status of the API
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_GetServiceStatus.html
    # @return [Peddler::XMLParser]
    def get_service_status
      operation('GetServiceStatus')
      run
    end

    # Creates an order reference for the given object
    #
    # @see http://docs.developer.amazonservices.com/en_US/off_amazon_payments/OffAmazonPayments_CreateOrderReferenceForId.html
    # @param id [String]
    # @param id_type [String]
    # @option opts [Boolean] :inherit_shipping_address
    # @option opts [Boolean] :confirm_now
    # @return [Peddler::XMLParser]
    def create_order_reference_for_id(id, id_type, opts = {})
      operation('CreateOrderReferenceForId')
        .add(opts.merge(
          'Id' => id,
          'IdType' => id_type
        ))

      run
    end
  end
end
