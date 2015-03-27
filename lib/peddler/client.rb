require 'forwardable'
require 'jeff'
require 'peddler/marketplace'
require 'peddler/operation'
require 'peddler/parser'

module Peddler
  # @abstract Subclass to implement an MWS API section.
  class Client
    extend Forwardable
    include Jeff

    attr_accessor :auth_token
    attr_writer :merchant_id, :marketplace_id, :path, :version
    attr_reader :body

    alias_method :configure, :tap

    def_delegators :marketplace, :host, :encoding

    params(
      'SellerId' => -> { merchant_id },
      'MWSAuthToken' => -> { auth_token }
    )

    class << self
      attr_reader :error_handler

      def parser
        @parser ||= Parser
      end

      def parser=(parser)
        @parser = parser
      end

      def path(path = nil)
        path ? @path = path : @path ||= '/'
      end

      def version(version = nil)
        version ? @version = version : @version ||= ""
      end

      def on_error(&blk)
        @error_handler = blk
      end

      private

      def inherited(base)
        base.params(params)
        base.on_error &@error_handler if @error_handler
      end
    end

    def initialize(opts = {})
      opts.each { |k, v| send("#{k}=", v) }
    end

    def aws_endpoint
      "https://#{host}#{path}"
    end

    def marketplace_id
      @marketplace_id ||= ENV['MWS_MARKETPLACE_ID']
    end

    def merchant_id
      @merchant_id ||= ENV['MWS_MERCHANT_ID']
    end

    def marketplace
      @marketplace ||= find_marketplace
    end

    def defaults
      @defaults ||= { expects: 200 }
    end

    def headers
      @headers ||= {}
    end

    def path
      @path ||= self.class.path
    end

    def version
      @version ||= self.class.version
    end

    def body=(str)
      headers['Content-Type'] = content_type(str)
      @body = str
    end

    def on_error(&blk)
      @error_handler = blk
    end

    def error_handler
      @error_handler || self.class.error_handler
    end

    def operation(action = nil)
      action ? @operation = Operation.new(action) : @operation
    end

    def run
      operation.store('Version', version) unless version.to_s == ""
      opts = defaults.merge(query: operation, headers: headers)
      opts.store(:body, body) if body
      opts.store(:response_block, Proc.new) if block_given?
      res = post(opts)

      parser.new(res, encoding)
    rescue Excon::Errors::Error => e
      handle_error(e) or raise
    rescue NoMethodError => e
      if e.message == "undefined method `new' for #{parser}"
        warn "[DEPRECATION] `Parser.parse` is deprecated. Please use `Parser.new` instead."
        parser.parse(res, encoding)
      else
        raise
      end
    end

    private

    def find_marketplace
      Marketplace.new(marketplace_id)
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
