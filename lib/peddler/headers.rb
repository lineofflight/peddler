module Peddler
  # Parses MWS-specific headers
  module Headers
    Quota = Struct.new(:max, :remaining, :resets_on)

    def quota
      return if headers.keys.none? { |key| key.include?('quota') }

      Quota.new(
        headers['x-mws-quota-max'].to_i,
        headers['x-mws-quota-remaining'].to_i,
        Time.parse(headers['x-mws-quota-resetsOn'])
      )
    end

    def request_id
      headers['x-mws-request-id']
    end

    def timestamp
      Time.parse(headers['x-mws-timestamp'])
    end

    def response_context
      headers['x-mws-response-context']
    end
  end
end
