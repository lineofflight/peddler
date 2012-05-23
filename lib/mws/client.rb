require 'aws-url'
require 'faraday'

require 'mws/api/products'

require 'mws/endpoint'
require 'mws/response'
require 'peddler/user_agent'

module MWS
  BadResponse = Class.new StandardError

  # A client to Amazon Marketplace Web Service (MWS) APIs.
  class Client
    include API::Products

    USER_AGENT = Peddler::UserAgent.build

    # Returns the MWS::Endpoint.
    attr :endpoint

    # Creates a new client.
    #
    # locale - A String locale name.
    def initialize(locale)
      @endpoint = Endpoint.new locale
    end

    # Internal: Builds a parameter list for bulk operations.
    # 
    # name   - The String base name of the keys.
    # values - A String value or an Array of values.
    #
    # Returns a Hash of parameters.
    def build_list(name, values)
      Array(values).to_enum(:each_with_index).inject({}) do |a, (v, i)|
        a.update "#{name}List.#{name}.#{i + 1}" => v
      end
    end

    # Configures the credentials of the endpoint.
    #
    # hsh - The Hash credentials of the endpoint (default: nil).
    #      :key       - The String AWS access key id.
    #      :seller_id - The String seller id.
    #      :secret    - The String AWS access secret key.
    #
    # Yields the MWS::Endpoint if a block is given.
    #
    # Returns nothing.
    def configure(hsh = nil, &blk)
      if block_given?
        yield @endpoint
      else
        hsh.each { |k, v| @endpoint.send "#{k}=", v }
      end
    end

    # Returns a Faraday::Connection.
    #
    # Yields a Faraday::Builder to configure the connection if a block is
    # given.
    def connection(&blk)
      @connection ||= begin
        Faraday.new :headers => { 'User-Agent' => USER_AGENT }, &blk
      end
    end

    private

    def url_builder(base_url)
      AWS::URL.new base_url, @endpoint.key, @endpoint.secret
    end
  end
end
