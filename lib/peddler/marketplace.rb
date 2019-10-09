# frozen_string_literal: true

module Peddler
  # @api private
  # @see https://docs.developer.amazonservices.com/en_US/dev_guide/DG_Endpoints.html
  Marketplace = Struct.new(:id, :country_code, :host) do
    class << self
      attr_reader :all

      def find(key)
        marketplace = if key.nil?
                        missing_key!
                      elsif key.size == 2
                        find_by_country_code(key)
                      else
                        find_by_id(key)
                      end

        marketplace || not_found!(key)
      end

      private

      def find_by_country_code(country_code)
        country_code = 'GB' if country_code == 'UK'
        all.find { |marketplace| marketplace.country_code == country_code }
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

    def encoding
      case country_code
      when 'JP'
        'Windows-31J'
      else
        'CP1252'
      end
    end

    @all = [
      ['A2EUQ1WTGCTBG2', 'CA', 'mws.amazonservices.com'],
      ['A1AM78C64UM0Y8', 'MX', 'mws.amazonservices.com'],
      ['ATVPDKIKX0DER', 'US', 'mws.amazonservices.com'],
      ['A2Q3Y263D00KWC', 'BR', 'mws.amazonservices.com'],
      ['A2VIGQ35RCS4UG', 'AE', 'mws.amazonservices.ae'],
      ['A1PA6795UKMFR9', 'DE', 'mws-eu.amazonservices.com'],
      ['A1RKKUPIHCS9HS', 'ES', 'mws-eu.amazonservices.com'],
      ['A13V1IB3VIYZZH', 'FR', 'mws-eu.amazonservices.com'],
      ['APJ6JRA9NG5V4', 'IT', 'mws-eu.amazonservices.com'],
      ['A1F83G8C2ARO7P', 'GB', 'mws-eu.amazonservices.com'],
      ['A33AVAJ2PDY3EV', 'TR', 'mws-eu.amazonservices.com'],
      ['A21TJRUUN4KGV', 'IN', 'mws.amazonservices.in'],
      ['A39IBJ37TRP1C6', 'AU', 'mws.amazonservices.com.au'],
      ['A1VC38T7YXB528', 'JP', 'mws.amazonservices.jp']
    ].map do |values|
      new(*values)
    end
  end
end
