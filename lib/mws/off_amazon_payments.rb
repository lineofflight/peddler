require 'peddler/client'

module MWS
  # The Off-Amazon Payments API helps you to process payments for purchases
  # made by buyers on your website using the Login and Pay with Amazon service.
  # This API enables you to programmatically retrieve shipping and payment
  # information provided by the buyer from their Amazon account. It allows you
  # to authorize, capture, and refund payments, enabling a variety of payments
  # scenarios.
  #
  # @todo Not implemented
  class OffAmazonPayments < ::Peddler::Client
    path 'OffAmazonPayments/2013-01-01/'
  end
end
