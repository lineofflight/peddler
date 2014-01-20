require 'yaml'
require 'helper'
require 'vcr'

VCR.configure do |c|
  c.hook_into :excon
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.default_cassette_options = {
    match_requests_on: [:method, VCR.request_matchers.uri_without_param(*%w(AWSAccessKeyId SellerId StartDate Signature Timestamp CreatedAfter))]
  }
end

class IntegrationTest < MiniTest::Test
  class << self
    attr_accessor :api
  end

  def accounts
    skip if ENV['SKIP_INTEGRATION']
    YAML.load_file(File.expand_path('../fixtures/mws.yml', __FILE__))
  rescue Errno::ENOENT
    skip('Credentials missing')
  end

  def setup
    @clients = accounts.map { |mws| self.class.api.const_get(:Client).new(*mws.values) }
  end
end
