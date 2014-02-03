require 'forwardable'
require 'nokogiri'

module Peddler
  class Response
    extend Forwardable

    attr :http_response

    def_delegator :http_response, :body

    def initialize(http_response, xml_namespace = 'xmlns:')
      @http_response = http_response
      @xml_namespace = xml_namespace
    end

    def document
      Nokogiri::XML(body)
    end

    def result_node
      root = document.root
      path = root.name.sub('Response', 'Result')

      root.xpath("#{@xml_namespace}#{path}")
    end
  end
end
