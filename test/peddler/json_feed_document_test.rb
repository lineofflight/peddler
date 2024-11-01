# frozen_string_literal: true

require "helper"

require "peddler/apis/feeds_2021_06_30"
require "peddler/json_feed_document"

module Peddler
  class JSONFeedDocumentTest < Minitest::Test
    include FeatureHelpers

    def document
      @document ||= JSONFeedDocument.new(api.sandbox)
    end

    def test_upload
      skip("spike feed document")

      content = { "foo" => "bar" }
      document.upload(content)

      assert_predicate(document, :uploaded?)
    end

    private

    def api_class
      APIs::Feeds20210630
    end
  end
end
