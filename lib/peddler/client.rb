require 'forwardable'
require 'jeff'

module Peddler
  class Client
    extend Forwardable
    include Jeff

    attr_accessor :default_country, :merchant_id

    def initialize(default_country = nil, aws_access_key_id = nil, aws_secret_access_key = nil, merchant_id = nil)
      @default_country = default_country
      @aws_access_key_id = aws_access_key_id || ENV['AWS_ACCESS_KEY_ID']
      @aws_secret_access_key = aws_secret_access_key || ENV['AWS_SECRET_ACCESS_KEY']
      @merchant_id = merchant_id || ENV['MERCHANT_ID']
    end

    HOSTS = {
      'CA' => 'mws.amazonservices.ca',
      'CN' => 'mws.amazonservices.com.cn',
      'DE' => 'mws-eu.amazonservices.com',
      'ES' => 'mws-eu.amazonservices.com',
      'FR' => 'mws-eu.amazonservices.com',
      'GB' => 'mws-eu.amazonservices.com',
      'IN' => 'mws.amazonservices.in',
      'IT' => 'mws-eu.amazonservices.com',
      'JP' => 'mws.amazonservices.jp',
      'US' => 'mws.amazonservices.com'
    }

    MARKETPLACE_IDS = {
      'CA' => 'A2EUQ1WTGCTBG2',
      'CN' => 'AAHKV2X7AFYLW',
      'DE' => 'A1PA6795UKMFR9',
      'ES' => 'A1RKKUPIHCS9HS',
      'FR' => 'A13V1IB3VIYZZH',
      'GB' => 'A1F83G8C2ARO7P',
      'IN' => 'A21TJRUUN4KGV',
      'IT' => 'APJ6JRA9NG5V4',
      'JP' => 'A1VC38T7YXB528',
      'US' => 'ATVPDKIKX0DER'
    }

    def self.path(path = nil)
      path ? @path = path : @path
    end

    def self.inherited(base)
      base.params(params)
    end

    params('SellerId' => -> { merchant_id })

    def aws_endpoint
      "https://#{HOSTS.fetch(default_country)}/#{self.class.path}"
    end

    def marketplace_id(country = default_country)
      MARKETPLACE_IDS.fetch(country)
    end
  end
end
