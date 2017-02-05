require 'peddler/client'
require 'securerandom'

module Null
  class Client < ::Peddler::Client
    def configure_with_mock_data!
      self.aws_access_key_id = SecureRandom.hex
      self.aws_secret_access_key = SecureRandom.hex
      self.merchant_id = SecureRandom.hex
      self.primary_marketplace_id = 'ATVPDKIKX0DER'
    end
  end

  module Parser
    def self.new(res, *)
      res
    end
  end

  Client.parser = Parser
end
