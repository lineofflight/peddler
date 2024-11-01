# frozen_string_literal: true

module Peddler
  class JSONFeedDocument
    CONTENT_TYPE = "application/json; charset=UTF-8"

    def upload(content)
      # While HTTPrb already sets the content-type, Amazon server seems to fail if we don't explicitly set it again
      # here. A bit of a mystery; maybe it's the order of the headers that's screwing things up on their end?
      HTTP.headers("Content-Type" => CONTENT_TYPE).put(url, json: content)
    end

    def initialize(api)
      @api = api
    end

    def id
      metadata.fetch("id")
    end

    def url
      metadata.fetch("url")
    end

    private

    def metadata
      @metadata ||= @api.create_feed_document({ "contentType" => CONTENT_TYPE }).parse
    end
  end
end
