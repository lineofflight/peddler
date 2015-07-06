module Peddler
  # @api private
  class Marketplace
    HOSTS = {
      'A2EUQ1WTGCTBG2' => 'mws.amazonservices.ca',
      'AAHKV2X7AFYLW'  => 'mws.amazonservices.com.cn',
      'A1PA6795UKMFR9' => 'mws-eu.amazonservices.com',
      'A1RKKUPIHCS9HS' => 'mws-eu.amazonservices.com',
      'A13V1IB3VIYZZH' => 'mws-eu.amazonservices.com',
      'A1F83G8C2ARO7P' => 'mws-eu.amazonservices.com',
      'A21TJRUUN4KGV'  => 'mws.amazonservices.in',
      'APJ6JRA9NG5V4'  => 'mws-eu.amazonservices.com',
      'A1VC38T7YXB528' => 'mws.amazonservices.jp',
      'A1AM78C64UM0Y8' => 'mws.amazonservices.com.mx',
      'ATVPDKIKX0DER'  => 'mws.amazonservices.com'
    }

    BadId = Class.new(StandardError)

    attr_reader :id

    def initialize(id)
      @id = id or fail BadId, 'missing MarketplaceId'
    end

    def host
      @host ||= find_host
    end

    def encoding
      if japanese?
        # Caveat: I've had one instance in the past where Shift_JIS didn't
        # work but Windows-31J did when parsing a report.
        'Shift_JIS'
      elsif chinese?
        'UTF-16'
      else
        'ISO-8859-1'
      end
    end

    private

    def find_host
      HOSTS.fetch(id) { fail BadId, %("#{id}" is not a valid MarketplaceId) }
    end

    def japanese?
      host.end_with?('jp')
    end

    def chinese?
      host.end_with?('cn')
    end
  end
end
