require 'forwardable'
require 'mws/cart_information'
require 'mws/customer_information'
require 'mws/feeds'
require 'mws/fulfillment_inbound_shipment'
require 'mws/fulfillment_inventory'
require 'mws/fulfillment_outbound_shipment'
require 'mws/off_amazon_payments'
require 'mws/orders'
require 'mws/products'
require 'mws/recommendations'
require 'mws/reports'
require 'mws/sellers'
require 'mws/subscriptions'

module MWS
  class << self
    extend Forwardable

    MWS.constants.each do |klass|
      method_name = klass.to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase
      def_delegator MWS.const_get(klass), :new, method_name
    end
  end
end
