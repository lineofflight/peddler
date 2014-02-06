require 'parser_helper'
require 'mws/subscriptions/parsers/registered_destinations'

class SubscriptionsRegisteredDestinationsParserTest < ParserTest
  def setup
    node = fixture('subscriptions/registered_destinations').xpath('//xmlns:ListRegisteredDestinationsResult')
    @destinations = MWS::Subscriptions::Parsers::RegisteredDestinations.new(node)
  end

  def test_has_destinations
    refute @destinations.empty?
    @destinations.each do |destination|
      assert_kind_of MWS::Subscriptions::Parsers::RegisteredDestination, destination
    end
  end
end
