require 'helper'
require 'excon'
require 'peddler/client'

class TestPeddlerClient < MiniTest::Test
  module Parser
    def self.new(res, *)
      res
    end
  end

  def setup
    @body = 'foo'
    Excon.defaults[:mock] = true
    Excon.stub({}, body: @body, status: 200)

    @klass = Class.new(Peddler::Client)
    @klass.parser = Parser
    @client = @klass.new
    @client.aws_access_key_id = 'key'
    @client.aws_secret_access_key = 'secret'
    @client.merchant_id = 'seller'
    @client.primary_marketplace_id = 'ATVPDKIKX0DER' # US
    @client.operation('Foo')
  end

  def teardown
    Excon.stubs.clear
    Excon.defaults.delete(:mock)
  end

  def test_configures_path
    @klass.path('/Foo')
    assert @client.aws_endpoint.match(%r{/Foo$})
  end

  def test_instance_path_overrides_class_path
    @klass.path('/Foo')

    @client.path = '/Foo/Bar'
    assert @client.aws_endpoint.match(%r{/Foo/Bar$})
  end

  def test_default_path
    assert_equal '/', @klass.path
  end

  def test_has_user_agent
    assert @client.connection.data[:headers].key?('User-Agent')
  end

  def test_inherits_parents_params
    assert_equal Peddler::Client.params, @klass.params
  end

  def test_params_include_seller_id
    assert @klass.params.key?("SellerId")
  end

  def test_params_include_auth_token
    @klass.params.key?("MWSAuthToken")
  end

  def test_configures
    @client.configure do |config|
      config.aws_access_key_id = '123'
    end

    assert_equal '123', @client.aws_access_key_id
  end

  def test_configures_when_initialising
    client = @klass.new(aws_access_key_id: '123')
    assert_equal '123', client.aws_access_key_id
  end

  def test_sets_content_type_header_for_latin_flat_file_body
    @client.body = 'foo'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/tab-separated-values; charset=ISO-8859-1', content_type
  end

  def test_sets_content_type_header_for_chinese_flat_file_body
    @client.primary_marketplace_id = 'AAHKV2X7AFYLW'
    @client.body = 'foo'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/tab-separated-values; charset=UTF-16', content_type
  end

  def test_sets_content_type_header_for_japanese_flat_file_body
    @client.primary_marketplace_id = 'A1VC38T7YXB528'
    @client.body = 'foo'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/tab-separated-values; charset=Shift_JIS', content_type
  end

  def test_sets_content_type_header_for_xml_body
    @client.body = '<?xml version="1.0"?><Foo></Foo>'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/xml', content_type
  end

  def test_runs_a_request
    res = @client.run
    assert_equal @body, res.body
  end

  def test_streams_response
    chunks = ''
    streamer = ->(chunk, _, _) { chunks << chunk }
    @client.run(&streamer)

    assert_equal @body, chunks
  end

  def test_request_preserves_user_agent
    instrumentor = Class.new
    class << instrumentor
      attr_accessor :events

      def instrument(name, params = {})
        events.update(name => params)
        yield if block_given?
      end
    end
    instrumentor.events = {}

    @client.defaults.update(instrumentor: instrumentor)
    @client.run
    headers = instrumentor.events['excon.request'][:headers]

    assert headers.key?('User-Agent')
  end

  def test_error_callback_on_class
    Excon.stub({}, status: 503)

    assert_raises(Excon::Errors::ServiceUnavailable) do
      @client.run
    end

    @klass.on_error do |e|
      assert_equal 503, e.response.status
    end
    @client.run # no longer raises

    Excon.stubs.clear
  end

  def test_error_callback_on_instance
    Excon.stub({}, status: 503)

    assert_raises(Excon::Errors::ServiceUnavailable) do
      @client.run
    end

    @client.on_error do |e|
      assert_equal 503, e.response.status
    end
    @client.run

    Excon.stubs.clear
  end

  def test_error_callback_on_client_ancestor
    Excon.stub({}, status: 503)

    @klass.on_error do |e|
      assert_equal 503, e.response.status
    end
    @client.run # no longer raises

    klass = Class.new(Peddler::Client)
    klass.parser = Parser
    other_client = klass.new
    other_client.aws_access_key_id = 'key'
    other_client.aws_secret_access_key = 'secret'
    other_client.merchant_id = 'seller'
    other_client.primary_marketplace_id = 'ATVPDKIKX0DER' # US
    other_client.operation('Foo')
    assert_raises(Excon::Errors::ServiceUnavailable) do
      other_client.run
    end

    Excon.stubs.clear
  end

  def test_decorates_error_response
    res = {
      body: '<ErrorResponse><Error>Foo</Error></ErrorResponse>',
      status: 503
    }
    Excon.stub({}, res)
    e = nil

    begin
      @client.run
    rescue => e
      assert e.response.parse
    end

    assert e
  end

  def test_deprecated_error_callback
    Excon.stub({}, status: 503)

    @client.on_error do |_, res|
      assert_equal 503, res.status
    end
    assert_output nil, /DEPRECATION/ do
      @client.run
    end

    Excon.stubs.clear
  end

  def test_deprecated_marketplace_id_accessor
    refute_nil @client.marketplace_id
    @client.marketplace_id = "123"
    assert_equal "123", @client.marketplace_id
    assert_equal @client.primary_marketplace_id, @client.marketplace_id
  end
end
