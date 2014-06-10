require 'helper'
require 'mws/order_reference_object'

class MWSOrderReferenceObjectTest < MiniTest::Test
  def test_state_predicates
    oro = MWS::OrderReferenceObject.new('donkey')

    oro.stub(:state, :draft)     { assert oro.draft?, true }
    oro.stub(:state, :open)      { assert oro.open?, true }
    oro.stub(:state, :suspended) { assert oro.suspended?, true }
    oro.stub(:state, :canceled)  { assert oro.canceled?, true }
    oro.stub(:state, :closed)    { assert oro.closed?, true }
  end

  def test_fetch
    peddler = stubbed_peddler(EXAMPLE_ORO_XML)
    oro = MWS::OrderReferenceObject.new('donkey', peddler)
    oro.fetch!

    assert oro.response_object.body.length > 0
  end

  def test_partial_destination_address_true
    peddler = stubbed_peddler(EXAMPLE_ORO_XML_PARTIAL)
    oro = MWS::OrderReferenceObject.new('donkey', peddler)
    oro.fetch!

    assert oro.partial_destination_address?
  end

  def test_partial_destination_address_false
    peddler = stubbed_peddler(EXAMPLE_ORO_XML)
    oro = MWS::OrderReferenceObject.new('donkey', peddler)
    oro.fetch!

    assert !oro.partial_destination_address?
  end

  def test_state
    peddler = stubbed_peddler(EXAMPLE_ORO_XML)
    oro = MWS::OrderReferenceObject.new('donkey', peddler)
    oro.fetch!

    assert_equal :open, oro.state
  end


  private

  def stubbed_peddler(xml)
    response = Class.new(Excon::Response) do
      define_method(:body) { xml }
    end.new

    peddler = Minitest::Mock.new
    peddler.expect(:get_order_reference_details, response, ['donkey'])

    peddler
  end

  EXAMPLE_ORO_XML = <<-BODY
    <GetOrderReferenceDetailsResponse xmlns="http://mws.amazonservices.com/schema/OffAmazonPayments/2013-01-01">
      <GetOrderReferenceDetailsResult>
        <OrderReferenceDetails>
          <AmazonOrderReferenceId>S01-5689543-2487366</AmazonOrderReferenceId>
          <ExpirationTimestamp>2014-12-02T20:42:40.148Z</ExpirationTimestamp>
          <OrderTotal>
            <Amount>45.00</Amount>
            <CurrencyCode>USD</CurrencyCode>
          </OrderTotal>
          <IdList/>
          <Destination>
            <DestinationType>Physical</DestinationType>
            <PhysicalDestination>
              <Phone>800-000-0000</Phone>
              <PostalCode>60602</PostalCode>
              <Name>Susie Smith</Name>
              <CountryCode>US</CountryCode>
              <StateOrRegion>IL</StateOrRegion>
              <AddressLine2>Suite 2500</AddressLine2>
              <AddressLine1>10 Ditka Ave</AddressLine1>
              <City>Chicago</City>
            </PhysicalDestination>
          </Destination>
          <OrderReferenceStatus>
            <LastUpdateTimestamp>2014-06-05T22:32:36.535Z</LastUpdateTimestamp>
            <State>Open</State>
          </OrderReferenceStatus>
          <ReleaseEnvironment>Sandbox</ReleaseEnvironment>
          <Buyer>
            <Email>horp@dorpenschtein.com</Email>
            <Name>Horp Dorpenschtein</Name>
          </Buyer>
          <SellerOrderAttributes/>
          <CreationTimestamp>2014-06-05T20:42:40.148Z</CreationTimestamp>
        </OrderReferenceDetails>
      </GetOrderReferenceDetailsResult>
      <ResponseMetadata>
        <RequestId>be2b2d32-81d0-4500-896c-2c056645d67f</RequestId>
      </ResponseMetadata>
    </GetOrderReferenceDetailsResponse>
  BODY

  EXAMPLE_ORO_XML_PARTIAL = <<-BODY
    <GetOrderReferenceDetailsResponse xmlns="http://mws.amazonservices.com/schema/OffAmazonPayments/2013-01-01">
      <GetOrderReferenceDetailsResult>
        <OrderReferenceDetails>
          <ExpirationTimestamp>2014-12-02T20:42:40.148Z</ExpirationTimestamp>
          <AmazonOrderReferenceId>S01-5689543-2487366</AmazonOrderReferenceId>
          <Constraints>
            <Constraint>
              <ConstraintID>AmountNotSet</ConstraintID>
              <Description>The seller has not set the amount for the Order Reference.</Description>
            </Constraint>
          </Constraints>
          <IdList/>
          <Destination>
            <DestinationType>Physical</DestinationType>
            <PhysicalDestination>
              <PostalCode>60602</PostalCode>
              <CountryCode>US</CountryCode>
              <StateOrRegion>IL</StateOrRegion>
              <City>Chicago</City>
            </PhysicalDestination>
          </Destination>
          <OrderReferenceStatus>
            <State>Draft</State>
          </OrderReferenceStatus>
          <ReleaseEnvironment>Sandbox</ReleaseEnvironment>
          <SellerOrderAttributes/>
          <CreationTimestamp>2014-06-05T20:42:40.148Z</CreationTimestamp>
        </OrderReferenceDetails>
      </GetOrderReferenceDetailsResult>
      <ResponseMetadata>
        <RequestId>ec2f944a-e278-4365-a404-22fff48c27eb</RequestId>
      </ResponseMetadata>
    </GetOrderReferenceDetailsResponse>
  BODY
end
