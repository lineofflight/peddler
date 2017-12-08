require 'credentials'
require 'helper'
require 'recorder'

class IntegrationTest < MiniTest::Test
  include Recorder

  private

  def clients
    api = @api || test_name
    ::Credentials.map { |credentials| MWS.const_get("#{api}::Client").new(credentials) }.shuffle
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

  Credentials.each do |record|
    c.filter_sensitive_data('FILTERED') { record['merchant_id'] }
    c.filter_sensitive_data('FILTERED') { record['aws_access_key_id'] }
  end
end
