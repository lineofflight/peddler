require 'peddler/request'
require 'mws/subscriptions/parsers/destination'

module MWS
  module Subscriptions
    module Requests
      class Destination < ::Peddler::Request
        def register(sqs_queue_url, marketplace_id = client.marketplace_id)
          execute_action('RegisterDestination', sqs_queue_url, marketplace_id)
        end

        def deregister(sqs_queue_url, marketplace_id = client.marketplace_id)
          execute_action('DeregisterDestination', sqs_queue_url, marketplace_id)
        end

        def send_test_notification_to(sqs_queue_url, marketplace_id = client.marketplace_id)
          execute_action('SendTestNotificationToDestination', sqs_queue_url, marketplace_id)
        end

        private

        def execute_action(action, sqs_queue_url, marketplace_id)
          parameters(action)
            .update(marketplace_id: marketplace_id)
            .update(destination(sqs_queue_url))
            .timestamp!
            .camelize_keys!

          execute
        end

        def destination(sqs_queue_url)
          {
            'Destination.DeliveryChannel' => 'SQS',
            'Destination.AttributeList.member.1.Key' => 'sqsQueueUrl',
            'Destination.AttributeList.member.1.Value' => sqs_queue_url
          }
        end
      end
    end
  end
end
