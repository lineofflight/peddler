require 'jeff'

module Peddler
  BadLocale     = Class.new ArgumentError
  MissingSeller = Class.new ArgumentError

  # A wrapper around a Marketplace Web Services (MWS) endpoint.
  class Service
    include Jeff

    class << self
      # Gets/Sets the path of the MWS endpoint.
      #
      # path - A String path (optional).
      def path(path = nil)
        @path = path if path
        @path
      end
    end

    params 'SellerId' => -> { seller }

    # A list of MWS hosts.
    HOSTS = {
      'CA' => 'mws.amazonservices.ca',
      'CN' => 'mws.amazonservices.com.cn',
      'DE' => 'mws-eu.amazonservices.com',
      'ES' => 'mws-eu.amazonservices.com',
      'FR' => 'mws-eu.amazonservices.com',
      'IN' => 'mws.amazonservices.in',
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
      'IN' => nil,
      'IT' => 'APJ6JRA9NG5V4',
      'JP' => 'A1VC38T7YXB528',
      'UK' => 'A1F83G8C2ARO7P',
      'US' => 'ATVPDKIKX0DER'
    }

    def self.inherited(base)
      base.params params
    end

    # Creates a new service endpoint for given locale.
    #
    # locale - The String MWS API locale.
    #
    # Raises a Bad Locale error if locale is not valid.
    def initialize(locale)
      @host = HOSTS[@locale = locale] or raise BadLocale
    end

    # Configures the MWS endpoint.
    #
    # credentials - The Hash credentials.
    #               :key    - The String Amazon Web Services (AWS) key.
    #               :secret - The String AWS secret.
    #               :seller - The String MWS Seller Id.
    #
    # Returns nothing.
    def configure(credentials)
      credentials.each { |key, val| self.send "#{key}=", val }
    end

    # Returns the String MWS endpoint.
    def endpoint
      "https://#{@host}/#{self.class.path}"
    end

    # Returns a String Marketplace id.
    #
    # locale - The String MWS API locale (default: the locale of the service
    #          endpoint).
    def marketplace(locale = nil)
      MARKETPLACES[locale || @locale] or raise BadLocale
    end

    # Gets the String MWS seller id.
    #
    # Raises a Missing Seller error if seller id is missing.
    def seller
      @seller or raise MissingSeller
    end

    # Sets the String MWS seller id.
    attr_writer :seller

    # Gets the String service status.
    def status
      get(query: { 'Action' => 'GetServiceStatus' })
        .body
        .match(/GREEN_?I?|YELLOW|RED/)[0]
    end
  end
end
