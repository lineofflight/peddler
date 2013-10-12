require 'peddler/request'
require 'mws/sellers/parsers/service_status'

module MWS
  module Sellers
    module Requests
      class ServiceStatus < ::Peddler::Request
        def get
          parameters(:get_service_status)
          execute
        end
      end
    end
  end
end
