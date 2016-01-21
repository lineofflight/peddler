require 'simplecov'
require 'coveralls'

SimpleCov.formatters = [
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]

SimpleCov.start do
  add_filter '/test/'
end

require 'dig_rb'
require 'minitest/autorun'
require 'peddler/vcr_matcher'
require 'yaml'
require 'vcr'
begin
  require 'pry'
rescue LoadError # rubocop:disable HandleExceptions
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

  %w(mws.yml mws.yml.example).each do |path|
    file = File.expand_path("../#{path}", __FILE__)
    if File.exist?(file)
      @data = YAML.load_file(file)
      break
    end
  end
end

# Bootstraps VCR
module Recorder
  def setup
    ENV['LIVE'] ? VCR.turn_off! : VCR.insert_cassette(test_name)
  end

  def teardown
    VCR.eject_cassette if VCR.turned_on?
  end

  def test_name
    self.class.name.sub('Test', '')
  end
end

# Sets up clients for integration testing
class IntegrationTest < MiniTest::Test
  include Recorder

  def clients
    Accounts.map do |account|
      klass = MWS.const_get("#{test_name}::Client")
      klass.new(account)
    end
  end
end

VCR.configure do |c|
  c.hook_into :excon
  c.cassette_library_dir = 'test/vcr_cassettes'

  ::Peddler::VCRMatcher.ignore_seller!

  # HTTP errors are not Peddler's concern, so ignore them to ease development.
  c.before_record do |interaction|
    code = interaction.response.status.code
    interaction.ignore! if code >= 400 && code != 414
  end
  c.default_cassette_options = {
    match_requests_on: [::Peddler::VCRMatcher],
    record: !ENV['RECORD'] ? :none : :new_episodes
  }

  # So that fixtures do not depend on merchant credentials
  Accounts.each do |account|
    c.filter_sensitive_data('MERCHANT_ID') { account['merchant_id'] }
    c.filter_sensitive_data('AWS_ACCESS_KEY_ID') { account['aws_access_key_id'] }
    c.before_record do |interaction|
      %w(
        BuyerName BuyerEmail Name AddressLine1 PostalCode Phone Amount
      ).each do |key|
        interaction.response.body.gsub!(/<#{key}>[^<]+</, "<#{key}>FILTERED<")
      end
    end
  end
end
