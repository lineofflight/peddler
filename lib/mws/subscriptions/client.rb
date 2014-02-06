require 'mws/subscriptions/requests/destination'
require 'mws/subscriptions/requests/registered_destinations'
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

      # Public: Registers a new destination where you want to receive
      # notifications.
      #
      # Examples
      #
      #   client.register_destination('https://foo/123/bar')
      #
      # Returns a Destination.
      def_delegator :destination, :register, :register_destination

      # Public: Removes an existing destination from the list of registered
      # destinations.
      #
      # Examples
      #
      #   client.deregister_destination('https://foo/123/bar')
      #
      # Returns a Destination.
      def_delegator :destination, :deregister, :deregister_destination

      # Public: Sends a test notification to an existing destination.
      #
      # Examples
      #
      #   client.send_test_notification_to('https://foo/123/bar')
      #
      # Returns a Destination.
      def_delegator :destination, :send_test_notification_to, :send_test_notification_to_destination

      # Public: Lists all the Destination you have registered to receive
      # notifications.
      #
      # Examples
      #
      #   client.list_registered_destinations
      #
      # Returns Registered Destinations.
      def_delegator :registered_destinations, :list, :list_registered_destinations

      # Public: Get the service status of the API.
      #
      # Examples
      #
      #   client.get_service_status
      #
      # Returns the Service Status.
      def_delegator :service_status, :get, :get_service_status

      private

      def destination
        @destination ||= Requests::Destination.new(self)
      end

      def registered_destinations
        @registered_destinations ||= Requests::RegisteredDestinations.new(self)
      end

      def service_status
        @service_status ||= Requests::ServiceStatus.new(self)
      end
    end
  end
end
