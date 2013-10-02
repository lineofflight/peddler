require 'nokogiri'

require 'peddler/request/parameters'

module Peddler
  class Request
    def self.inherited(subclass)
    end
    attr :client

    attr_accessor :last_response

    def initialize(client)
      @client = client
    end

    def next_token
      node = document.at_xpath('//xmlns:NextToken')
      node.text if node
    end

    private

    def execute
      fetch
      parse
    end

    def fetch
      @last_response = client.post(query: parameters)
    end

    def parse
      parser.new(parser.handle?(:xml) ? node : body)
    end

    def parameters(action = nil)
      @parameters = Parameters.new(action) if action
      @parameters
    end

    def parser
      Object.const_get(self.class.name.sub('Request', 'Parser'))
    end

    def body
      last_response.body
    end

    def document
      Nokogiri::XML(body)
    end

    def node
      document.xpath("//xmlns:#{name}")
    end

    def name
      self.class.name.split('::').last
    end
  end
end
