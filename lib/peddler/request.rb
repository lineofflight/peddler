require 'nokogiri'

require 'peddler/request/parameters'

module Peddler
  class Request
    attr :client, :headers, :last_response

    attr_accessor :body

    def initialize(client)
      @client = client
      @headers = {}
    end

    def next_token
      node = xml_payload.at_xpath('xmlns:NextToken')
      node.text if node
    end

    def parameters(action = nil)
      @parameters = Parameters.new(action) if action
      @parameters
    end

    def execute
      fetch
      parse
    end

    private

    def parser
      @parser ||= Object.const_get(self.class.name.sub('Request', 'Parser'))
    end

    def fetch
      opts = { query: parameters }
      opts[:headers] = headers unless headers.empty?
      opts[:body] = body if body

      # TODO Extract Response into a new class.
      @last_response = client.post(opts)
    end

    def parse
      parser.new(parser.handle?(:xml) ? xml_payload : last_response_body)
    end

    def last_response_body
      last_response.body
    end

    def document
      Nokogiri::XML(last_response_body)
    end

    def xml_payload
      root = document.root
      path = root.name.sub('Response', 'Result')

      root.xpath("xmlns:#{path}")
    end
  end
end
