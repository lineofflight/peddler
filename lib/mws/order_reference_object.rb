require 'mws/off_amazon_payments'
require 'mws/oap_object'
require 'nokogiri'

module MWS
  # This class models an Amazon Order Reference Object, which is a record created on their end to track information
  # about orders placed using Off-Amazon Payments.
  #
  # Please feel free to add more accessor methods for pieces of data you find yourself frequently drilling down
  # to get.
  class OrderReferenceObject < OAPObject
    PARTIAL_ADDRESS_CONTRAINT = "AmountNotSet"
    STATES = %i(draft open suspended canceled closed)

    def fetch!
      @response_object = api.get_order_reference_details(id)
    end

    STATES.each do |s|
      define_method("#{s}?") { state == s }
    end

    def state
      at_path(%[
        GetOrderReferenceDetailsResponse
        GetOrderReferenceDetailsResult
        OrderReferenceDetails
        OrderReferenceStatus
        State
      ]).downcase.to_sym
    end

    def partial_destination_address?
      at_path?(%[
        GetOrderReferenceDetailsResponse
        GetOrderReferenceDetailsResult
        OrderReferenceDetails
        Constraints
        Constraint
        ConstraintID
       ], PARTIAL_ADDRESS_CONTRAINT)
    end
  end
end
