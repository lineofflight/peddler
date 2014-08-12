require 'yaml'
require 'vcr'

require 'helper'

VCR.configure do |c|
  c.hook_into :excon
  c.cassette_library_dir = 'test/vcr_cassettes'

  c.before_record do |interaction|
    interaction.ignore! if interaction.response.status.code >= 400
  end

  nondeterministic_params = %w(Signature Timestamp StartDate CreatedAfter QueryStartDateTime)
  matcher = VCR.request_matchers.uri_without_param(*nondeterministic_params)
  c.default_cassette_options = {
    match_requests_on: [:method, matcher],
    record: :new_episodes
  }
end

class IntegrationTest < MiniTest::Test
  def api_name
    self.class.name.match(/(.*)Test/)[1]
  end

  def clients
    accounts = begin
      YAML.load_file(File.expand_path('../mws.yml', __FILE__)).shuffle
    rescue Errno::ENOENT
      warn('Skipping integration tests')
      []
    end

    accounts.map do |account|
      klass = MWS.const_get(api_name).const_get(:Client)
      klass.new.configure do |c|
        account.each { |k, v| c.send("#{k}=", v) }
      end
    end
  end

  def setup
    ENV['LIVE'] ? VCR.turn_off! : VCR.insert_cassette(api_name)
  end

  def teardown
    VCR.eject_cassette if VCR.turned_on?
  end
end
