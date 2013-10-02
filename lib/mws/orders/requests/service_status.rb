require 'peddler/request'
require 'mws/orders/parsers/service_status'

module MWS
  module Orders
    module Requests
      class ServiceStatus < ::Peddler::Request
        def get
          parameters(:get_service_status)
          execute
        end

        private

        def node
          document.xpath("//xmlns:GetServiceStatusResult")
        end
      end
    end
  end
end
