require 'forwardable'
require 'nokogiri'

module Peddler
  class ResponseWrapper
    extend Forwardable

    def_delegator :response, :body

    attr :response

    def initialize(response)
      @response = response
    end

    def document
      Nokogiri::XML(body)
    end

    def result_node
      root = document.root
      path = root.name.sub('Response', 'Result')

      root.xpath("xmlns:#{path}")
    end

    def next_token
      node = result_node.at_xpath('xmlns:NextToken')
      node.text if node
    end
  end
end
