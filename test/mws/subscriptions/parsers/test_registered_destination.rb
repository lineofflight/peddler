require 'parser_helper'
require 'mws/subscriptions/parsers/registered_destination'

class SubscriptionsRegisteredDestinationParserTest < ParserTest
  def setup
    node = fixture('subscriptions/registered_destinations').xpath('//xmlns:DestinationList/xmlns:member')
    @destination = MWS::Subscriptions::Parsers::RegisteredDestination.new(node)
  end

  def test_has_delivery_channel
    assert_kind_of String, @destination.delivery_channel
  end

  def test_has_sqs_queue_url
    assert_kind_of String, @destination.sqs_queue_url
  end
end
