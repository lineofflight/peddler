require 'peddler/client'

module MWS
  module CustomerInformation
    # With the Customer Information API, you can retrieve information from the
    # customer accounts of your Amazon Webstore customers. This customer
    # information includes customer name, contact information, customer account
    # type, and associated Amazon Webstore marketplaces. The Customer
    # Information API enables you to programmatically integrate Amazon Webstore
    # customer account information with your CRM systems, marketing
    # applications, and other systems that require customer data.
    #
    # @note The Customer Information API section only returns customer
    #   information for Webstores with Seller-Branded Checkout. No customer
    #   information is returned for Webstores with Amazon.com checkout. If your
    #   Webstore offers both checkout options, customer information is returned
    #   only for Seller-Branded Checkout accounts.
    # @note In addition to registering for Amazon MWS, you must request
    #   authorization to use the Customer Information API.
    class Client < ::Peddler::Client
      version "2014-03-01"
      path "/CustomerInformation/#{version}"

      # Lists customer accounts based on search criteria that you specify
      #
      # @see http://docs.developer.amazonservices.com/en_US/customer_info/CustomerInfo_ListCustomers.html
      # @param opts [Hash]
      # @option opts [String] :marketplace_id
      # @option opts [String, #iso8601] :date_range_start
      # @option opts [String, #iso8601] :date_range_end
      # @option opts [String] :date_range_type
      # @return [Peddler::XMLParser]
      def list_customers(opts = {})
        operation('ListCustomers')
          .add(opts)

        run
      end

      # Lists the next page of customer accounts
      #
      # @see http://docs.developer.amazonservices.com/en_US/customer_info/CustomerInfo_ListCustomersByNextToken.html
      # @param next_token [String]
      # @return [Peddler::XMLParser]
      def list_customers_by_next_token(next_token)
        operation('ListCustomersByNextToken')
          .add('NextToken' => next_token)

        run
      end

      # Returns customer accounts based on the CustomerId values that you
      # specify
      #
      # @see http://docs.developer.amazonservices.com/en_US/customer_info/CustomerInfo_GetCustomersForCustomerId.html
      # @overload get_customers_for_customer_id(*customer_id_list, opts = {})
      #   @param customer_id_list [Array<String>]
      #   @param opts [Hash]
      #   @option opts [String] :marketplace_id
      # @return [Peddler::XMLParser]
      def get_customers_for_customer_id(*customer_id_list)
        opts = extract_options(customer_id_list)
        operation('GetCustomersForCustomerId')
          .add(opts.update('CustomerIdList' => customer_id_list))
          .structure!('CustomerIdList', 'CustomerId')

        run
      end

      # Gets the service status of the API
      #
      # @see http://docs.developer.amazonservices.com/en_US/customer_info/MWS_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end
    end
  end
end
