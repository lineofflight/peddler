# frozen_string_literal: true

require "helper"

require "peddler/apis/reports_2021_06_30"

module Peddler
  class CustomParserTest < Minitest::Test
    include FeatureHelpers

    def test_custom_parser_on_instance
      api.parser = custom_parser
      res = api.get_report("1234567")

      assert_nil(api_class.parser)
      assert(api.parser)
      assert(res.dig(:reportId))
    end

    def test_custom_parser_on_class
      klass = Class.new(api_class)
      klass.parser = custom_parser
      access_token = request_access_token(grantless: false)
      api = klass.new(aws_region, access_token)
      res = api.get_report("1234567")

      assert_nil(api_class.parser)
      assert(klass.parser)
      assert(res.dig(:reportId))
    end

    private

    def custom_parser
      ->(response) { JSON.parse(response, symbolize_names: true) }
    end

    def api_class
      APIs::Reports20210630
    end
  end
end
