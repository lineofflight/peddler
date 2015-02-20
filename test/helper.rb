require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require 'yaml'
require 'vcr'
begin
  require 'pry'
rescue LoadError
end

# Wraps MWS credentials to run integration tests against
#
# Replace entries in the fixture file with real credentials if adding new tests
# or otherwise testing against live data.
module Accounts
  extend Enumerable

  def self.each(&blk)
    @data.each(&blk)
  end

  @data = YAML.load_file(File.expand_path('../mws.yml', __FILE__))
end

# Sets up clients and bootstraps VCR for integration tests
class IntegrationTest < MiniTest::Test
  def setup
    ENV['LIVE'] ? VCR.turn_off! : VCR.insert_cassette(api)
  end

  def teardown
    VCR.eject_cassette if VCR.turned_on?
  end

  def clients
    Accounts.map do |account|
      klass = MWS.const_get("#{api}::Client")
      klass.new(account)
    end
  end

  private

  def api
    self.class.name.sub('Test', '')
  end
end

VCR.configure do |c|
  c.hook_into :excon
  c.cassette_library_dir = 'test/vcr_cassettes'

  # HTTP errors are not Peddler's concern, so ignore them to ease development.
  c.before_record do |interaction|
    interaction.ignore! if interaction.response.status.code >= 400
  end

  # Ignore transient params when building VCR fixtures.
  matcher = VCR.request_matchers.uri_without_param(
    'AWSAccessKeyId', 'SellerId', 'Signature', 'Timestamp', 'StartDate',
    'CreatedAfter', 'QueryStartDateTime'
  )

  c.default_cassette_options = {
    match_requests_on: [:host, :path, matcher],
    record: :none
  }

  # So that fixtures do not depend on merchant credentials
  Accounts.each do |account|
    c.filter_sensitive_data('MERCHANT_ID') { account['merchant_id'] }
    c.filter_sensitive_data('AWS_ACCESS_KEY_ID') { account['aws_access_key_id'] }
  end
end
