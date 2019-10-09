# frozen_string_literal: true

module Peddler
  # Parses MWS metadata provided in the headers of a response
  class MWS
    # @api private
    attr_reader :headers

    # @api private
    def initialize(headers)
      @headers = headers.select { |key| key.start_with?('x-mws') }
    end

    # The max hourly request quota for the requested operation
    # @return [Integer, nil]
    def quota_max
      return unless headers['x-mws-quota-max']

      headers['x-mws-quota-max'].to_i
    end

    # The remaining hourly request quota for the requested operation
    # @return [Integer, nil]
    def quota_remaining
      return unless headers['x-mws-quota-remaining']

      headers['x-mws-quota-remaining'].to_i
    end

    # When the hourly request quota for the requested operation resets
    # @return [Time, nil]
    def quota_resets_on
      return unless headers['x-mws-quota-resetsOn']

      Time.parse(headers['x-mws-quota-resetsOn'])
    end

    # The ID of the request
    # @return [String, nil]
    def request_id
      headers['x-mws-request-id']
    end

    # The timestamp of the request
    # @return [Time, nil]
    def timestamp
      return unless headers['x-mws-timestamp']

      Time.parse(headers['x-mws-timestamp'])
    end

    # The context of the response
    # @return [String, nil]
    def response_context
      headers['x-mws-response-context']
    end
  end
end
