require 'helper'
require 'excon'
require 'peddler/client'

class PeddlerClientTest < MiniTest::Test
  module Parser
    def self.parse(res, *); res; end
  end

  def setup
    @body = 'foo'
    Excon.defaults[:mock] = true
    Excon.stub({}, body: @body, status: 200)

    @klass = Class.new(Peddler::Client)
    @client = @klass.new

    @client.aws_access_key_id = 'key'
    @client.aws_secret_access_key = 'secret'
    @client.merchant_id = 'seller'
    @client.marketplace_id = 'ATVPDKIKX0DER' # US

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
    assert @client.connection.data[:headers].has_key?('User-Agent')
  end

  def test_inherits_parents_params
    assert_equal Peddler::Client.params, @klass.params
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

  def test_guards_against_bad_marketplace_id
    assert_raises(Peddler::UnknownMarketplaceIdError) do
      client = Peddler::Client.new
      client.marketplace_id = '123'
      client.get
    end
  end

  def test_sets_content_type_header_for_latin_flat_file_body
    @client.body = 'foo'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/tab-separated-values; charset=ISO-8859-1', content_type
  end

  def test_sets_content_type_header_for_chinese_flat_file_body
    @client.marketplace_id = 'AAHKV2X7AFYLW'
    @client.body = 'foo'
    content_type = @client.headers.fetch('Content-Type')

    assert_equal 'text/tab-separated-values; charset=UTF-16', content_type
  end

  def test_sets_content_type_header_for_japanese_flat_file_body
    @client.marketplace_id = 'A1VC38T7YXB528'
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
    res = @client.run(Parser)
    assert_equal @body, res.body
  end

  def test_streams_response
    chunks = ''
    streamer = ->(chunk, _, _) { chunks << chunk }
    @client.run(Parser, &streamer)

    assert_equal @body, chunks
  end

  def test_raises_pretty_error
    response = Class.new do
      define_method(:body) { "<Error><Code>DerpHerps</Code><Message>Such pretty, so message</Message></Error>" }
    end.new

    excon_error = Class.new(StandardError) do
      define_method(:request) { "Whatevs" }
      define_method(:response) { response }
    end.new

    assert_raises Peddler::ApiError do
      @client.with_pretty_error_handling { raise excon_error }
    end

    begin
      @client.with_pretty_error_handling { raise excon_error }
    rescue Peddler::ApiError => e
      assert_equal e.message, "DerpHerps: Such pretty, so message"
    end
  end
end
