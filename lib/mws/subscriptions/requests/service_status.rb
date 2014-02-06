require 'peddler/request'
require 'mws/subscriptions/parsers/service_status'

module MWS
  module Subscriptions
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
