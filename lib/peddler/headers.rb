# frozen_string_literal: true

module Peddler
  # Parses MWS-specific headers
  module Headers
    Quota = Struct.new(:max, :remaining, :resets_on)

    # The present quota, if available, for the requested MWS operation
    # @return [Struct, nil]
    def mws_quota
      return if headers.keys.none? { |key| key.include?('quota') }

      Quota.new(
        headers['x-mws-quota-max'].to_i,
        headers['x-mws-quota-remaining'].to_i,
        Time.parse(headers['x-mws-quota-resetsOn'])
      )
    end

    # The ID assigned by MWS to the HTTP request
    # @return [String]
    def mws_request_id
      headers['x-mws-request-id']
    end

    # The timestamp of the MWS HTTP response
    # @return [String]
    def mws_timestamp
      Time.parse(headers['x-mws-timestamp'])
    end

    # The context of the MWS HTTP response
    # @return [String]
    def mws_response_context
      headers['x-mws-response-context']
    end
  end
end
