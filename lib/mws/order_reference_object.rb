require 'mws/off_amazon_payments'
require 'mws/oap_object'
require 'nokogiri'

module MWS
  # This class models an Amazon Order Reference Object, which is a record created on their end to track information
  # about orders placed using Off-Amazon Payments.
  class OrderReferenceObject < OAPObject
    PARTIAL_ADDRESS_CONTRAINT = "AmountNotSet"
    STATES = %i(draft open suspended canceled closed)

    STATES.each do |s|
      define_method("#{s}?") { state == s }
    end

    def fetch!
      @response_object = api.get_order_reference_details(id)
    end

    def partial_destination_address?
      css("Constraints > Constraint > ConstraintID").include?(PARTIAL_ADDRESS_CONTRAINT)
    end

    def state
      css("OrderReferenceStatus > State").downcase.to_sym
    end
  end
end
