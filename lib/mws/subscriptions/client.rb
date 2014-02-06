require 'mws/subscriptions/requests/service_status'
require 'peddler/client'

module MWS
  module Subscriptions
    # The Amazon MWS Subscriptions API section enables you to subscribe to
    # receive notifications that are relevant to your business with Amazon. With
    # the operations in the Subscriptions API section, you can register to
    # receive important information from Amazon without having to poll the
    # Amazon MWS service. Instead, the information is sent directly to you when
    # an event occurs to which you are subscribed.
    class Client < ::Peddler::Client
      path 'Subscriptions/2013-07-01'

      # Public: Get the service status of the API.
      #
      # Examples
      #
      #   client.get_service_status
      #
      # Returns the Service Status.
      def_delegator :service_status, :get, :get_service_status

      private

      def service_status
        @service_status ||= Requests::ServiceStatus.new(self)
      end
    end
  end
end
