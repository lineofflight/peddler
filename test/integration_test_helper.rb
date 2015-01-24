require 'yaml'
require 'vcr'
require 'test_helper'

class IntegrationTest < MiniTest::Test
  ACCOUNTS = YAML.load_file(File.expand_path('../mws.yml', __FILE__))

  def api_name
    self.class.name.match(/Test(.*)/)[1]
  end

  def clients
    ACCOUNTS.map do |account|
      MWS.const_get(api_name).const_get(:Client).new(account)
    end
  end

  def setup
    ENV['LIVE'] ? VCR.turn_off! : VCR.insert_cassette(api_name)
  end

  def teardown
    VCR.eject_cassette if VCR.turned_on?
  end
end

VCR.configure do |c|
  c.hook_into :excon
  c.cassette_library_dir = 'test/vcr_cassettes'

  c.before_record do |interaction|
    interaction.ignore! if interaction.response.status.code >= 400
  end

  matcher = VCR.request_matchers.uri_without_param(
    'AWSAccessKeyId', 'SellerId', 'Signature', 'Timestamp', 'StartDate',
    'CreatedAfter', 'QueryStartDateTime'
  )
  c.default_cassette_options = {
    match_requests_on: [:host, :path, matcher],
    record: :none
  }

  IntegrationTest::ACCOUNTS.each do |account|
    c.filter_sensitive_data('MERCHANT_ID') { account.fetch('merchant_id') }
    c.filter_sensitive_data('AWS_ACCESS_KEY_ID') { account.fetch('aws_access_key_id') }
  end
end
