require 'nokogiri'

require 'mws/xml'

module MWS
  # A wrapper around an Amazon Marketplace Web Service (MWS) response.
  class Response
    # Returns the String response body.
    attr :body

    # Returns the Integer HTTP response code.
    attr :status

    # Creates a new Response.
    #
    # response - A Faraday::Response.
    def initialize(response)
      @body, @status = response.body, response.status
    end

    # Queries the response body.
    #
    # query - String query.
    #
    # Yields matching nodes to a given block if given one.
    #
    # Returns an Array of matching nodes or the return values of the yielded
    # block if latter was given.
    def find(query)
      path = if xml.namespaces.empty?
               "//#{query}"
             else
               "//xmlns:#{query}"
             end

      xml.xpath(path).map do |node|
        hsh = XML.to_hash node
        block_given? ? yield(hsh) : hsh
      end
    end

    # Returns the first match to a query.
    #
    # query - String query.
    def first(query)
      find(query).first
    end

    # Returns a Hash representation of the response body.
    def to_hash
      XML.to_hash xml
    end

    # Returns whether the HTTP response is OK.
    def valid?
      @status == 200
    end

    # Returns the response body as a Nokogiri::XML::Document.
    def xml
      @xml ||= Nokogiri::XML.parse @body
    end
  end
end
