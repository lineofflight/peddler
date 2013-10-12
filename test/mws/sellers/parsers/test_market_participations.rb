require 'parser_helper'
require 'mws/sellers/parsers/marketplace_participations'

class SellerMarketParticipationsParserTest < ParserTest
  def setup
    node = fixture('sellers/market_participations').xpath('//xmlns:ListMarketplaceParticipationsResult')
    @mp = MWS::Sellers::Parsers::MarketplaceParticipations.new(node)
  end

  def test_has_marketplaces
    refute_empty @mp.marketplaces
    @mp.marketplaces.each { |marketplace| assert_kind_of MWS::Sellers::Parsers::Marketplace, marketplace }
  end

  def test_has_participations
    refute_empty @mp.participations
    @mp.participations.each { |participation| assert_kind_of MWS::Sellers::Parsers::Participation, participation }
  end
end
