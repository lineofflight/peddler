require 'jeff'

module Peddler
  # Service is an abstract wrapper around a Marketplace Web Services (MWS)
  # endpoint.
  #
  # Its initializer takes four arguments:
  #
  # marketplace           - The String ISO 3166-1 two-letter country code of
  #                         the Amazon marketplace (default: nil).
  # aws_access_key_id     - The String AWS access key id (default: nil).
  # aws_secret_access_key - The String AWS secret access key (default: nil).
  # seller_id             - The String MWS merchant id (default: nil).
  Service = Struct.new(:marketplace, :aws_access_key_id, :aws_secret_access_key, :seller_id) do
    # Jeff owns this service.
    include Jeff

    # Gets/Sets the path of the MWS endpoint.
    #
    # path - A String path (optional).
    def self.path(path = nil)
      path ? @path = path : @path
    end

    # Here we add SellerId to the default parameters already provided by Jeff.
    params('SellerId' => -> { seller_id })

    # A list of MWS hosts.
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

    # A list of MWS marketplace ids.
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

    def self.inherited(base)
      base.params(params)
    end

    # Returns the String MWS endpoint.
    def endpoint
      "https://#{HOSTS.fetch(marketplace)}/#{self.class.path}"
    end

    # Returns the String Marketplace id.
    def marketplace_id
      MARKETPLACE_IDS[marketplace]
    end

    # Query the operational status of the service.
    #
    # Returns a String GREEN, GREEN_I, YELLOW or RED status.
    def get_service_status
      res = get(query: { 'Action' => 'GetServiceStatus' })
        .body
        .match(/Status>([^<]+)/)[1]
    end
  end
end
