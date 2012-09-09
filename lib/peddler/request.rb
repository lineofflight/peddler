require 'jeff'

module Peddler
  BadLocale     = Class.new ArgumentError
  MissingSeller = Class.new ArgumentError

  # A request to an Marketplace Web Services (MWS) API endpoint.
  class Request
    include Jeff

    params 'SellerId' => -> { seller }

    # A list of MWS hosts.
    HOSTS = {
      'CA' => 'mws.amazonservices.ca',
      'CN' => 'mws.amazonservices.com.cn',
      'DE' => 'mws-eu.amazonservices.com',
      'ES' => 'mws-eu.amazonservices.com',
      'FR' => 'mws-eu.amazonservices.com',
      'IT' => 'mws-eu.amazonservices.com',
      'JP' => 'mws.amazonservices.jp',
      'UK' => 'mws-eu.amazonservices.com',
      'US' => 'mws.amazonservices.com'
    }

    # A list of MWS marketplace ids.
    MARKETPLACES = {
      'CA' => 'A2EUQ1WTGCTBG2',
      'CN' => nil,
      'DE' => 'A1PA6795UKMFR9',
      'ES' => 'A1RKKUPIHCS9HS',
      'FR' => 'A13V1IB3VIYZZH',
      'IT' => 'APJ6JRA9NG5V4',
      'JP' => 'A1VC38T7YXB528',
      'UK' => 'A1F83G8C2ARO7P',
      'US' => 'ATVPDKIKX0DER'
    }

    def self.inherited(base)
      base.params params
    end

    # Creates a new request for given locale.
    #
    # locale - The String MWS API locale.
    #
    # Raises a Bad Locale error if locale is not valid.
    def initialize(locale)
      @host = HOSTS[@locale = locale] or raise BadLocale
    end

    # Configures the Amazon Product Advertising API request.
    #
    # credentials - The Hash credentials of the API endpoint.
    #               :key    - The String Amazon Web Services (AWS) key.
    #               :secret - The String AWS secret.
    #               :seller - The String MWS Seller Id.
    #
    # Returns nothing.
    def configure(credentials)
      credentials.each { |key, val| self.send "#{key}=", val }
    end

    def endpoint
      raise NotImplementedError
    end

    # Returns a String Marketplace ID.
    #
    # locale - The String MWS API locale (default: the request locale).
    def marketplace(locale = nil)
      MARKETPLACES[locale || @locale] or raise BadLocale
    end

    def seller
      @seller or raise MissingSeller
    end

    attr_writer :seller
  end
end
