require 'forwardable'

require 'peddler/request/parameters'
require 'peddler/response_wrapper'

module Peddler
  class Request
    extend Forwardable

    def_delegator :last_parsed_response, :next_token

    attr :client, :headers

    attr_accessor :body, :last_parsed_response

    def initialize(client)
      @client = client
      @headers = {}
    end

    def parameters(action = nil)
      @parameters = Parameters.new(action) if action
      @parameters
    end

    def execute
      res = fetch
      parse(res)
    end

    def has_next_token?
      !!next_token
    end

    private

    def parser
      @parser ||= Object.const_get(self.class.name.sub('Request', 'Parser'))
    end

    def fetch
      opts = { query: parameters, headers: headers }
      opts.update(body: body) if body
      res = client.post(opts)

      ResponseWrapper.new(res)
    end

    def parse(response)
      document = parser.handle?(:xml) ? response.result_node : response.body
      @last_parsed_response = parser.new(document)
    end
  end
end
