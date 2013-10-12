require 'request_helper'
require 'mws/sellers/requests/marketplace_participations'

class MarketplaceParticipationsRequestTest < RequestTest
  def mock_response_body
    <<-EOF
      <Response xmlns="ns">
        <Result>
        <NextToken>MRgZW55IGNhcm5hbCBwbGVhc3VyZS6=</NextToken>
          <ListParticipations>
            <Participation>
            </Participation>
          </ListParticipations>
          <ListMarketplaces>
            <Marketplace>
            </Marketplace>
          </ListMarketplaces>
        </Result>
      </Response>
    EOF
  end

  def setup
    @mp = MWS::Sellers::Requests::MarketplaceParticipations.new(mock_client)
  end

  def test_lists_marketplace_participations
    res = @mp.list
    assert_kind_of MWS::Sellers::Parsers::MarketplaceParticipations, res
  end

  def test_gets_report_list_by_next_token
    mock_parsed_response = MiniTest::Mock.new
    mock_parsed_response.expect(:next_token, '123')
    @mp.last_parsed_response = mock_parsed_response
    res = @mp.list_by_next_token
    assert_kind_of MWS::Sellers::Parsers::MarketplaceParticipations, res
  end
end
