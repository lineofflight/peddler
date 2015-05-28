require 'forwardable'
require 'jeff'
require 'peddler/marketplace'
require 'peddler/operation'
require 'peddler/parser'

module Peddler
  # An abstract client
  #
  # Subclass to implement an MWS API section.
  #
  # rubocop:disable ClassLength
  class Client
    extend Forwardable
    include Jeff

    # The MWSAuthToken used to access another seller's account
    # @return [String]
    attr_accessor :auth_token

    attr_writer :merchant_id, :primary_marketplace_id, :path

    # @api private
    attr_writer :version

    # The body of the HTTP request
    # @return [String]
    attr_reader :body

    alias_method :configure, :tap

    def_delegators :marketplace, :host, :encoding

    params(
      'SellerId' => -> { merchant_id },
      'MWSAuthToken' => -> { auth_token },
      'Version' => -> { version }
    )

    class << self
      # @api private
      attr_reader :error_handler

      # @api private
      def parser
        @parser ||= Parser
      end

      attr_writer :parser

      # @api private
      def path(path = nil)
        path ? @path = path : @path ||= '/'
      end

      # @api private
      def version(version = nil)
        version ? @version = version : @version
      end

      # Sets an error handler
      # @yieldparam request [Excon::Request]
      # @yieldparam response [Excon::Response]
      def on_error(&blk)
        @error_handler = blk
      end

      private

      def inherited(base)
        base.params(params)
        base.on_error(&@error_handler) if @error_handler
      end
    end

    # Creates a new client instance
    #
    # @param opts [Hash]
    # @option opts [String] :marketplace_id
    # @option opts [String] :merchant_id
    # @option opts [String] :aws_access_key_id
    # @option opts [String] :aws_secret_access_key
    # @option opts [String] :auth_token
    def initialize(opts = {})
      opts.each { |k, v| send("#{k}=", v) }
    end

    # @api private
    def aws_endpoint
      "https://#{host}#{path}"
    end

    # The merchant's Marketplace ID
    # @!parse attr_reader :primary_marketplace_id
    # @return [String]
    def primary_marketplace_id
      @primary_marketplace_id ||= ENV['MWS_MARKETPLACE_ID']
    end

    # @deprecated Use {#primary_marketplace_id} instead.
    def marketplace_id
      warn "[DEPRECATION] `Client#marketplace_id` is deprecated. "\
           "Please use `Client#primary_marketplace_id` instead."
      @primary_marketplace_id
    end

    # @deprecated Use {#primary_marketplace_id=} instead.
    def marketplace_id=(marketplace_id)
      warn "[DEPRECATION] `Client#marketplace_id=` is deprecated. "\
           "Please use `Client#primary_marketplace_id=` instead."
      @primary_marketplace_id = marketplace_id
    end

    # The merchant's Seller ID
    # @!parse attr_reader :merchant_id
    # @return [String]
    def merchant_id
      @merchant_id ||= ENV['MWS_MERCHANT_ID']
    end

    # @api private
    def marketplace
      @marketplace ||= find_marketplace
    end

    # The HTTP path of the API
    # @!parse attr_reader :path
    # @return [String]
    def path
      @path ||= self.class.path
    end

    # @api private
    def version
      @version ||= self.class.version
    end

    # @!parse attr_writer :body
    def body=(str)
      headers['Content-Type'] = content_type(str)
      @body = str
    end

    # @api private
    def defaults
      @defaults ||= { expects: 200 }
    end

    # @api private
    def headers
      @headers ||= {}
    end

    # Sets an error handler
    # @yieldparam request [Excon::Request]
    # @yieldparam response [Excon::Response]
    def on_error(&blk)
      @error_handler = blk
    end

    # @api private
    def error_handler
      @error_handler || self.class.error_handler
    end

    # @api private
    def operation(action = nil)
      action ? @operation = Operation.new(action) : @operation
    end

    # @api private
    # rubocop:disable AbcSize, MethodLength
    def run
      opts = defaults.merge(query: operation, headers: headers)
      opts.store(:body, body) if body
      opts.store(:response_block, Proc.new) if block_given?
      res = post(opts)

      parser.new(res, encoding)
    rescue Excon::Errors::Error => e
      handle_error(e) or raise
    rescue NoMethodError => e
      if e.message == "undefined method `new' for #{parser}"
        warn "[DEPRECATION] `Parser.parse` is deprecated. "\
             "Please use `Parser.new` instead."
        parser.parse(res, encoding)
      else
        raise
      end
    end

    private

    def find_marketplace
      Marketplace.new(primary_marketplace_id)
    end

    def content_type(str)
      if str.start_with?('<?xml')
        'text/xml'
      else
        "text/tab-separated-values; charset=#{encoding}"
      end
    end

    def extract_options(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end

    def parser
      self.class.parser
    end

    def handle_error(e)
      return false unless error_handler
      error_handler.call(e.request, e.response)
    end
  end
end
