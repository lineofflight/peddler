# frozen_string_literal: true

require 'time'

module Peddler
  # Parses useful metadata returned in response headers
  module Headers
    # The size of the response body in bytes
    # @return [String, nil]
    def content_length
      return unless headers['Content-Length']

      headers['Content-Length'].to_i
    end

    # The MD5 digest of the response body
    # @return [String, nil]
    def content_md5
      headers['Content-MD5']
    end

    # The MIME type of the response
    # @return [String, nil]
    def content_media_type
      return unless headers['Content-Type']

      headers['Content-Type'].split(';').first
    end

    # The general category into which the MIME type falls
    # @return [String, nil]
    def content_type
      return unless content_media_type

      content_media_type.split('/').first
    end

    # The exact kind of data of the specified type the MIME type represents
    # @return [String, nil]
    def content_subtype
      return unless content_media_type

      content_media_type.split('/').last
    end

    # The character encoding of the response
    # @return [Encoding, nil]
    def content_charset
      match_data = headers['Content-Type']&.match(/charset=(.*);?/)
      return unless match_data

      string = match_data[1].upcase
      string = 'UTF-8' if string == 'UTF8'

      Encoding.find(string)
    end

    # The max hourly request quota for the requested operation
    # @return [Integer, nil]
    def mws_quota_max
      return unless headers['x-mws-quota-max']

      headers['x-mws-quota-max'].to_i
    end

    # The remaining hourly request quota for the requested operation
    # @return [Integer, nil]
    def mws_quota_remaining
      return unless headers['x-mws-quota-remaining']

      headers['x-mws-quota-remaining'].to_i
    end

    # When the hourly request quota for the requested operation resets
    # @return [Time, nil]
    def mws_quota_resets_on
      return unless headers['x-mws-quota-resetsOn']

      Time.parse(headers['x-mws-quota-resetsOn'])
    end

    # The ID of the request
    # @return [String, nil]
    def mws_request_id
      headers['x-mws-request-id']
    end

    # The timestamp of the request
    # @return [Time, nil]
    def mws_timestamp
      return unless headers['x-mws-timestamp']

      Time.parse(headers['x-mws-timestamp'])
    end

    # The context of the response
    # @return [String, nil]
    def mws_response_context
      headers['x-mws-response-context']
    end
  end
end
