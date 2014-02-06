require 'yaml'
require 'helper'
require 'vcr'

VCR.configure do |c|
  nondeterministic_params = %w(AWSAccessKeyId SellerId Signature Timestamp StartDate CreatedAfter Destination.AttributeList.member.1.Value)

  extract_query_value = ->(interaction, key) do
    query = URI.parse(interaction.request.uri).query
    query_values = CGI.parse(query)
    value = query_values[key].first
    CGI.escape(value) if value
  end

  c.hook_into :excon
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.default_cassette_options = {
    match_requests_on: [:method, VCR.request_matchers.uri_without_param(*nondeterministic_params)],
    record: :new_episodes
  }
  c.filter_sensitive_data('aws_access_key_id') { |interaction| extract_query_value.(interaction, 'AWSAccessKeyId') }
  c.filter_sensitive_data('seller_id') { |interaction| extract_query_value.(interaction, 'SellerId') }
  c.filter_sensitive_data('sqs_queue_url') { |interaction| extract_query_value.(interaction, 'Destination.AttributeList.member.1.Value') }
end

class IntegrationTest < MiniTest::Test
  class << self
    attr_accessor :api
  end

  def accounts
    YAML.load_file(File.expand_path('../fixtures/mws.yml', __FILE__))
  rescue Errno::ENOENT
    warn('Credentials not set')
    YAML.load_file(File.expand_path('../fixtures/mws.yml.example', __FILE__))
  end

  def setup
    @clients = accounts.map { |mws| self.class.api.const_get(:Client).new(*mws.values) }
  end
end
