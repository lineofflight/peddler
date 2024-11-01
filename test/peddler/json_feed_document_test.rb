# frozen_string_literal: true

require "helper"

require "peddler/apis/feeds_2021_06_30"
require "peddler/json_feed_document"

module Peddler
  class JSONFeedDocumentTest < Minitest::Test
    include FeatureHelpers

    def feed
      @feed ||= JSONFeedDocument.new(api)
    end

    def test_upload
      content = { "foo" => "bar" }
      res = feed.upload(content)

      assert_predicate(res.status, :ok?)
    end

    private

    def api_class
      APIs::Feeds20210630
    end
  end
end
