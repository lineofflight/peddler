require 'peddler/request/parameters'
require 'peddler/response'

module Peddler
  class Request
    attr :client, :headers

    attr_accessor :body, :last_parsed_response

    attr_writer :parser

    def initialize(client)
      @client = client
      @headers = {}
    end

    def parameters(action = nil)
      @parameters = Parameters.new(action) if action
      @parameters
    end

    def execute(&blk)
      if block_given?
        fetch(&blk)
      else
        res = Response.new(fetch)
        parse(res)
      end
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

    def fetch(&blk)
      opts = { query: parameters, headers: headers, idempotent: true, expects: 200 }
      opts.update(body: body) if body
      opts.update(response_block: blk) if block_given?

      client.post(opts)
    end

    def parse(response)
      document = parser.xml? ? response.result_node : response.body
      @last_parsed_response = parser.new(document)
    end
  end
end
