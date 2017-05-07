require 'helper'
require 'recorder'

%w[mws.yml mws.yml.example].each do |path|
  file = File.expand_path("../#{path}", __FILE__)
  if File.exist?(file)
    $mws = YAML.load_file(file)
    break
  end
end

class IntegrationTest < MiniTest::Test
  include Recorder

  private

  def clients
    api = @api || test_name
    $mws.map { |record| MWS.const_get("#{api}::Client").new(record) }.shuffle
  end
end

::Peddler::VCRMatcher.ignore_seller!

VCR.configure do |c|
  c.before_record do |interaction|
    %w[
      BuyerName BuyerEmail Name AddressLine1 PostalCode Phone Amount
    ].each do |key|
      interaction.response.body.gsub!(/<#{key}>[^<]+</, "<#{key}>FILTERED<")
    end
  end

  $mws.each do |record|
    c.filter_sensitive_data('FILTERED') { record['merchant_id'] }
    c.filter_sensitive_data('FILTERED') { record['aws_access_key_id'] }
  end
end
