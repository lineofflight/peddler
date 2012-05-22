module MWS
  # Some defensive coding.
  BadLocale       = Class.new ArgumentError
  MissingKey      = Class.new ArgumentError
  MissingSecret   = Class.new ArgumentError
  MissingSellerId = Class.new ArgumentError

  # An Amazon Marketplace Service (MWS) endpoint.
  class Endpoint
    # List of MWS hosts.
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

    # List of marketplace ids.
    #
    # TODO: Fill missing ids.
    MARKETPLACE_IDS = {
      'CA' => nil,
      'CN' => nil,
      'DE' => 'A1PA6795UKMFR9',
      'ES' => 'A1RKKUPIHCS9HS',
      'FR' => 'A13V1IB3VIYZZH',
      'IT' => 'APJ6JRA9NG5V4',
      'JP' => nil,
      'UK' => 'A1F83G8C2ARO7P',
      'US' => 'ATVPDKIKX0DER'
    }

    # Creates a new endpoint.
    #
    # locale - A String-like locale name.
    #
    # Raises BadLocale if locale is not valid.
    def initialize(locale)
      HOSTS.has_key? @locale = locale.to_s.upcase or raise BadLocale
    end

    # Returns the String MWS host.
    def host
      HOSTS[@locale]
    end

    # Returns the String AWS access key id.
    #
    # Raises MissingKey if key is not set.
    def key
      @key or raise MissingKey
    end

    # Sets the String AWS access key id.
    attr_writer :key

    # Gets the String marketplace id.
    def marketplace_id
      MARKETPLACE_IDS[@locale]
    end

    # Returns the String seller id.
    #
    # Raises SellerIdMissing if id is missing.
    def seller_id
      @seller_id or raise MissingSellerId
    end

    # Sets the String seller id.
    attr_writer :seller_id

    # Gets the String AWS access secret key.
    # 
    # Raises MissingSecret if secret is not set.
    def secret
      @secret or raise MissingSecret
    end

    # Sets the String AWS access secret key.
    attr_writer :secret
  end
end
