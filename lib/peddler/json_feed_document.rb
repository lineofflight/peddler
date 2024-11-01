# frozen_string_literal: true

module Peddler
  class JSONFeedDocument
    def initialize(api)
      @api = api
    end

    def id
      attributes.fetch("id")
    end

    def url
      attributes.fetch("url")
    end

    def upload(content)
      HTTP.put(url, json: content)
    end

    def get
      @api.get_feed_document(id).parse
    end

    private

    def attributes
      @attributes ||= @api.create_feed_document({ "contentType" => "application/json; charset=UTF-8" }).parse
    end
  end
end
