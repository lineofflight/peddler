require 'helper'
require 'peddler/order_reference_object'

class PeddlerOrderReferenceObjectTest < MiniTest::Test
  def test_initialization
    oro = Peddler::OrderReferenceObject.new('blah')
    assert_equal oro.oro_id, 'blah'
    assert oro.api.instance_of?(MWS::OffAmazonPayments)
  end

  def test_fetch!
    peddler = stubbed_peddler

    oro = Peddler::OrderReferenceObject.new('donkey', peddler)
    oro.fetch!

    assert oro.response_object.body.length > 0
  end

  private

  def stubbed_peddler
    response = Class.new(Excon::Response) do
      define_method(:body) { EXAMPLE_ORO_XML }
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
end
