require 'peddler/request/parameters'
require 'peddler/response_wrapper'

module Peddler
  class Request
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

    def next_token
      last_parsed_response.next_token if last_parsed_response
    end

    def has_next_token?
      !!next_token
    end

    private

    def parser
      @parser ||= Object.const_get(self.class.name.sub('Request', 'Parser'))
    end

    def fetch
      opts = { query: parameters, headers: headers, idempotent: true, expects: 200 }
      opts.update(body: body) if body
      res = client.post(opts)

      ResponseWrapper.new(res)
    end

    def parse(response)
      document = parser.xml? ? response.result_node : response.body
      @last_parsed_response = parser.new(document)
    end
  end
end
