require 'forwardable'

require 'peddler/request/parameters'
require 'peddler/response_wrapper'

module Peddler
  class Request
    extend Forwardable

    def_delegator :last_response, :next_token

    attr :client, :headers

    attr_accessor :body, :last_response

    def initialize(client)
      @client = client
      @headers = {}
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
      opts = { query: parameters, headers: headers }
      opts.update(body: body) if body
      res = client.post(opts)

      @last_response = ResponseWrapper.new(res)
    end

    def parse
      parser.new(parser.handle?(:xml) ? last_response.xml_payload : last_response.body)
    end
  end
end
