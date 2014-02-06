require 'peddler/parsers/model'

module MWS
  module Subscriptions
    module Parsers
      class RegisteredDestination < ::Peddler::Parsers::Model
        value :delivery_channel do
          text_at_xpath('DeliveryChannel')
        end

        value :sqs_queue_url do
          text_at_xpath('AttributeList/member/Value')
        end
      end
    end
  end
end
