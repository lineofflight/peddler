# frozen_string_literal: true

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
      self.version = '2013-07-01'
      self.path = "/Subscriptions/#{version}"

      # Registers a new destination to receive notifications
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_RegisterDestination.html
      # @param [String] sqs_queue_url
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def register_destination(sqs_queue_url, marketplace_id)
        operation('RegisterDestination')
          .add('MarketplaceId' => marketplace_id)
          .add(build_destination(sqs_queue_url))

        run
      end

      # Removes an existing destination from the list of registered destinations
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_DeregisterDestination.html
      # @param [String] sqs_queue_url
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def deregister_destination(sqs_queue_url, marketplace_id)
        operation('DeregisterDestination')
          .add('MarketplaceId' => marketplace_id)
          .add(build_destination(sqs_queue_url))

        run
      end

      # Lists all registered destinations
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_ListRegisteredDestinations.html
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def list_registered_destinations(marketplace_id)
        operation('ListRegisteredDestinations')
          .add('MarketplaceId' => marketplace_id)

        run
      end

      # Sends a test notification to an existing destination
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_SendTestNotificationToDestination.html
      # @param [String] sqs_queue_url
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def send_test_notification_to_destination(sqs_queue_url, marketplace_id)
        operation('SendTestNotificationToDestination')
          .add('MarketplaceId' => marketplace_id)
          .add(build_destination(sqs_queue_url))

        run
      end

      # Creates a new subscription
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_CreateSubscription.html
      # @param [String] notification_type
      # @param [String] sqs_queue_url
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def create_subscription(notification_type, sqs_queue_url, marketplace_id)
        operation('CreateSubscription')
          .add('MarketplaceId' => marketplace_id)
          .add(build_subscription(notification_type, sqs_queue_url))

        run
      end

      # Gets a subscription
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_GetSubscription.html
      # @param [String] notification_type
      # @param [String] sqs_queue_url
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def get_subscription(notification_type, sqs_queue_url, marketplace_id)
        operation('GetSubscription')
          .add('MarketplaceId' => marketplace_id,
               'NotificationType' => notification_type)
          .add(build_destination(sqs_queue_url))

        run
      end

      # Deletes a subscription
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_DeleteSubscription.html
      # @param [String] notification_type
      # @param [String] sqs_queue_url
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def delete_subscription(notification_type, sqs_queue_url, marketplace_id)
        operation('DeleteSubscription')
          .add('MarketplaceId' => marketplace_id,
               'NotificationType' => notification_type)
          .add(build_destination(sqs_queue_url))

        run
      end

      # Lists current subscriptions
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_ListSubscriptions.html
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def list_subscriptions(marketplace_id)
        operation('ListSubscriptions')
          .add('MarketplaceId' => marketplace_id)

        run
      end

      # Updates a subscription
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_UpdateSubscription.html
      # @param [String] notification_type
      # @param [String] sqs_queue_url
      # @param [Boolean] enabled
      # @param [String] marketplace_id
      # @return [Peddler::XMLParser]
      def update_subscription(notification_type, sqs_queue_url, enabled,
                              marketplace_id)
        operation('UpdateSubscription')
          .add('MarketplaceId' => marketplace_id)
          .add(build_subscription(notification_type, sqs_queue_url, enabled: enabled))

        run
      end

      # Gets the service status of the API
      #
      # @see https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_GetServiceStatus.html
      # @return [Peddler::XMLParser]
      def get_service_status
        operation('GetServiceStatus')
        run
      end

      private

      def build_destination(sqs_queue_url)
        {
          'Destination.DeliveryChannel' => 'SQS',
          'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
          'Destination.AttributeList.member.1.Value' => sqs_queue_url
        }
      end

      def build_subscription(notification_type, sqs_queue_url, enabled: true)
        {
          'Subscription.IsEnabled' => enabled,
          'Subscription.NotificationType' => notification_type,
          'Subscription.Destination.DeliveryChannel' => 'SQS',
          'Subscription.Destination.AttributeList.member.1.Key' =>
            'sqsQueueUrl',
          'Subscription.Destination.AttributeList.member.1.Value' =>
            sqs_queue_url
        }
      end
    end
  end
end
