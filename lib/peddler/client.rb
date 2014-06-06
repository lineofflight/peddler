require 'jeff'
require 'peddler/operation'
require 'peddler/parser'
require 'peddler/errors'
require 'nokogiri'

module Peddler
  # @abstract Subclass to implement an MWS API section.
  class Client
    include Jeff

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
      'ATVPDKIKX0DER'  => 'mws.amazonservices.com'
    }

    attr_accessor :path
    attr_writer :merchant_id, :marketplace_id
    attr_reader :body

    alias :configure :tap

    params('SellerId' => -> { merchant_id })

    def self.path(path = nil)
      path ? @path = path : @path ||= '/'
    end

    def self.inherited(base)
      base.params(params)
    end

    def initialize(opts = {})
      opts.each { |k, v| self.send("#{k}=", v) }
    end

    def aws_endpoint
      "https://#{host}#{self.path || self.class.path}"
    end

    def marketplace_id
      @marketplace_id ||= ENV['MWS_MARKETPLACE_ID']
    end

    def merchant_id
      @merchant_id ||= ENV['MWS_MERCHANT_ID']
    end

    def headers
      @headers ||= {}
    end

    def body=(str)
      headers['Content-Type'] = content_type(str)
      @body = str
    end

    def operation(action = nil)
      action ? @operation = Operation.new(action) : @operation
    end

    def run(parser = Parser, &blk)
      opts = { query: operation, headers: headers, expects: 200 }
      opts.store(:body, body) if body
      opts.store(:response_block, blk) if block_given?
      res = post(opts)

      parser.parse(res, host_encoding)
    end

    def with_pretty_error_handling
      yield

    rescue => e
      if e.respond_to?(:request) && e.respond_to?(:response)
        xml = Nokogiri::XML(e.response.body)
        raise Peddler::ApiError.new(e.request, e.response),
          "#{xml.at_css('Error > Code').text}: #{xml.at_css('Error > Message').text}"
      else
        raise
      end
    end

    private

    def content_type(str)
      if str.start_with?('<?xml')
        'text/xml'
      else
        "text/tab-separated-values; charset=#{host_encoding}"
      end
    end

    def host_encoding
      if host.end_with?('jp')
        # Caveat: I've had one instance in the past where Shift_JIS didn't
        # work but Windows-31J did when parsing a report.
        'Shift_JIS'
      elsif host.end_with?('cn')
        'UTF-16'
      else
        'ISO-8859-1'
      end
    end

    def host
      HOSTS.fetch(marketplace_id) do
        raise UnknownMarketplaceIdError, "Marketplace '#{marketplace_id}' not found in #{HOSTS.inspect}"
      end
    end

    def extract_options(args)
      args.last.is_a?(Hash) ? args.pop : {}
    end
  end
end
