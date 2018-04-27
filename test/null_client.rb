# frozen_string_literal: true

require 'peddler/client'
require 'securerandom'

module Null
  module Parser
    def self.new(res, *)
      res
    end
  end

  class Client < ::Peddler::Client
    self.path = '/'

    def configure_with_mock_data!
      self.aws_access_key_id = SecureRandom.hex
      self.aws_secret_access_key = SecureRandom.hex
      self.merchant_id = SecureRandom.hex
      self.marketplace = 'US'
    end

    self.parser = Parser
  end
end
