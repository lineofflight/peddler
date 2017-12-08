# frozen_string_literal: true

require 'credentials'
require 'helper'
require 'recorder'

class IntegrationTest < MiniTest::Test
  include Recorder

  class << self
    def use(endpoint)
      @current_endpoint = endpoint
    end

    def clients
      @clients ||= build_clients
    end

    private

    def build_clients
      klass = MWS.const_get("#{current_endpoint}::Client")
      ::Credentials.map { |credentials| klass.new(credentials) }.shuffle
    end

    def current_endpoint
      @current_endpoint || name.sub('Test', '')
    end
  end

  def clients
    self.class.clients
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
