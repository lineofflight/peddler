# frozen_string_literal: true

module Peddler
  # Parses content metadata provided in the headers of a response
  class Content
    # @api private
    attr_reader :headers

    # @api private
    def initialize(headers)
      @headers = headers.select { |key| key.start_with?('Content') }
    end

    # The size of the response body in bytes
    # @return [String, nil]
    def length
      return unless headers['Content-Length']

      headers['Content-Length'].to_i
    end

    # The MD5 digest of the response body
    # @return [String, nil]
    def md5
      headers['Content-MD5']
    end

    # The MIME type of the response
    # @return [String, nil]
    def media_type
      return unless headers['Content-Type']

      headers['Content-Type'].split(';').first
    end

    # The general category into which the MIME type falls
    # @return [String, nil]
    def type
      return unless media_type

      media_type.split('/').first
    end

    # The exact kind of data of the specified type the MIME type represents
    # @return [String, nil]
    def subtype
      return unless media_type

      media_type.split('/').last
    end

    # The character encoding of the response
    # @return [Encoding, nil]
    def charset
      match_data = headers['Content-Type']&.match(/charset=(.*);?/)
      return unless match_data

      Encoding.find(match_data[1])
    end

    # Whether the response is an XML document
    # @return [Boolean, nil]
    def xml?
      return unless subtype

      subtype == 'xml'
    end
  end
end
