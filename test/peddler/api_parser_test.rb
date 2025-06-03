# frozen_string_literal: true

require "helper"

require "peddler/apis/reports_2021_06_30"

module Peddler
  class APIParserTest < Minitest::Test
    def setup
      marketplace = Marketplace.all.sample

      @klass = Class.new(API) { def foo = get("") }
      @instance = @klass.new(marketplace.endpoint.aws_region, nil)
      @parser = -> { JSON.parse(it, symbolize_names: true) }

      stub_request(:get, marketplace.endpoint.production)
        .to_return(status: 200, body: '{"bar": true}', headers: { "Content-Type" => "application/json" })
    end

    def test_class_parser
      @klass.parser = @parser

      assert(@instance.foo.dig(:bar))
    end

    def test_instance_parser
      @instance.parser = @parser

      assert(@instance.foo.dig(:bar))
    end

    def test_parser_inheritance_isolation
      @klass.parser = @parser

      assert(@klass.parser)
      refute(API.parser)
    end

    def test_nil_clears_parser
      @instance.parser = @parser

      assert(@instance.foo.dig(:bar))
      @instance.parser = nil

      refute(@instance.foo.dig(:bar))
    end
  end
end
