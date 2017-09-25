module Peddler
  # @api private
  # @see https://docs.developer.amazonservices.com/en_US/dev_guide/DG_Endpoints.html
  class Marketplace
    IDS = {
      'CA' => 'A2EUQ1WTGCTBG2',
      'MX' => 'A1AM78C64UM0Y8',
      'US' => 'ATVPDKIKX0DER',
      'BR' => 'A2Q3Y263D00KWC',
      'DE' => 'A1PA6795UKMFR9',
      'ES' => 'A1RKKUPIHCS9HS',
      'FR' => 'A13V1IB3VIYZZH',
      'IT' => 'APJ6JRA9NG5V4',
      'UK' => 'A1F83G8C2ARO7P',
      'IN' => 'A21TJRUUN4KGV',
      'AU' => 'A39IBJ37TRP1C6',
      'JP' => 'A1VC38T7YXB528',
      'CN' => 'AAHKV2X7AFYLW'
    }.freeze

    HOSTS = {
      'CA' => 'mws.amazonservices.com',
      'MX' => 'mws.amazonservices.com',
      'US' => 'mws.amazonservices.com',
      'BR' => 'mws.amazonservices.com',
      'DE' => 'mws-eu.amazonservices.com',
      'ES' => 'mws-eu.amazonservices.com',
      'FR' => 'mws-eu.amazonservices.com',
      'IT' => 'mws-eu.amazonservices.com',
      'UK' => 'mws-eu.amazonservices.com',
      'IN' => 'mws.amazonservices.in',
      'AU' => 'mws.amazonservices.com.au',
      'JP' => 'mws.amazonservices.jp',
      'CN' => 'mws.amazonservices.com.cn'
    }.freeze

    BadId = Class.new(StandardError)

    attr_reader :id

    def initialize(id)
      @id = id || raise(BadId, 'missing MarketplaceId')
    end

    def country_code
      @country_code ||= find_country_code
    end

    def host
      @host ||= find_host
    end

    # Caveat: We use the supersets Windows-31J and CP1252 in place of Shift_JIS
    # and ISO 8859-1 respectively to handle edge cases where latter will not
    # support some characters. The supersets should be safe to use as drop-in
    # replacements.
    def encoding
      case country_code
      when 'JP'
        'Windows-31J'
      when 'CN'
        'UTF-16'
      else
        'CP1252'
      end
    end

    private

    def find_country_code
      IDS.key(id) || raise(BadId, %("#{id}" is not a valid MarketplaceId))
    end

    def find_host
      HOSTS[country_code]
    end
  end
end
