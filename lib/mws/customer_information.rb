require 'peddler/client'

module MWS
  # With the Customer Information API, you can retrieve information from the
  # customer accounts of your Amazon Webstore customers. This customer
  # information includes customer name, contact information, customer account
  # type, and associated Amazon Webstore marketplaces. The Customer Information
  # API enables you to programmatically integrate Amazon Webstore customer
  # account information with your CRM systems, marketing applications, and other
  # systems that require customer data.
  #
  # @todo Not implemented
  class CustomerInformation < ::Peddler::Client
    path '/CustomerInformation/2014-03-01'
  end
end
