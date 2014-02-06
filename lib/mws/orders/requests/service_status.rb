require 'peddler/request'
require 'mws/orders/parsers/service_status'

module MWS
  module Orders
    module Requests
      class ServiceStatus < ::Peddler::Request
        def get
          parameters('GetServiceStatus')
          execute
        end
      end
    end
  end
end
