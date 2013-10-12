require 'parser_helper'
require 'mws/sellers/parsers/service_status'

class SellersServiceStatusParserTest < ParserTest
  def setup
    node = fixture('sellers/service_status').xpath('//xmlns:GetServiceStatusResult').first
    @service_status = MWS::Sellers::Parsers::ServiceStatus.new(node)
  end

  def test_status
    assert_kind_of String, @service_status.status
  end

  def test_timestamp
    assert_kind_of Time, @service_status.timestamp
  end

  def test_messages
    assert_kind_of Array, @service_status.messages
  end

  def test_ok?
    @service_status.stub(:status, 'GREEN') do
      assert @service_status.ok?
    end

    @service_status.stub(:status, 'RED') do
      refute @service_status.ok?
    end
  end

  def test_inspect
    assert_equal @service_status.status, @service_status.to_s
  end
end
