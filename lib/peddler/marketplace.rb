# frozen_string_literal: true

module Peddler
  # @!visibility private
  # @see https://docs.developer.amazonservices.com/en_US/dev_guide/DG_Endpoints.html
  class Marketplace
    class << self
      attr_reader :all

      def find(key)
        missing_key! unless key
        marketplace = key.size == 2 ? find_by_country(key) : find_by_id(key)

        marketplace || not_found!(key)
      end

      private

      def find_by_country(code)
        code = 'GB' if code == 'UK'
        all.find { |marketplace| marketplace.country_code == code }
      end

      def find_by_id(id)
        all.find { |marketplace| marketplace.id == id }
      end

      def missing_key!
        raise ArgumentError, 'missing marketplace'
      end

      def not_found!(country_code)
        raise ArgumentError, %("#{country_code}" is not a valid marketplace)
      end
    end

    attr_reader :id, :country_code, :host

    def initialize(id, country_code, host)
      @id = id
      @country_code = country_code
      @host = host
    end

    def encoding
      case country_code
      when 'JP'
        'Windows-31J'
      else
        'CP1252'
      end
    end

    @all = [
      ['A2Q3Y263D00KWC', 'BR', 'mws.amazonservices.com'],
      ['A2EUQ1WTGCTBG2', 'CA', 'mws.amazonservices.com'],
      ['A1AM78C64UM0Y8', 'MX', 'mws.amazonservices.com'],
      ['ATVPDKIKX0DER', 'US', 'mws.amazonservices.com'],
      ['A2VIGQ35RCS4UG', 'AE', 'mws.amazonservices.ae'],
      ['A1PA6795UKMFR9', 'DE', 'mws-eu.amazonservices.com'],
      ['ARBP9OOSHTCHU', 'EG', 'mws-eu.amazonservices.com'],
      ['A1RKKUPIHCS9HS', 'ES', 'mws-eu.amazonservices.com'],
      ['A13V1IB3VIYZZH', 'FR', 'mws-eu.amazonservices.com'],
      ['A1F83G8C2ARO7P', 'GB', 'mws-eu.amazonservices.com'],
      ['A21TJRUUN4KGV', 'IN', 'mws.amazonservices.in'],
      ['APJ6JRA9NG5V4', 'IT', 'mws-eu.amazonservices.com'],
      ['A1805IZSGTT6HS', 'NL', 'mws-eu.amazonservices.com'],
      ['A17E79C6D8DWNP', 'SA', 'mws-eu.amazonservices.com'],
      ['A33AVAJ2PDY3EV', 'TR', 'mws-eu.amazonservices.com'],
      ['A2NODRKZP88ZB9', 'SE', 'mws-eu.amazonservices.com'],
      ['A19VAU5U5O7RUS', 'SG', 'mws-fe.amazonservices.com'],
      ['A39IBJ37TRP1C6', 'AU', 'mws.amazonservices.com.au'],
      ['A1VC38T7YXB528', 'JP', 'mws.amazonservices.jp']
    ].map do |values|
      new(*values)
    end
  end
end
