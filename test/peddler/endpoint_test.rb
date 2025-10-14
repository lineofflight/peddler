# frozen_string_literal: true

require "helper"

module Peddler
  class EndpointTest < Minitest::Test
    def setup
      @endpoint = Endpoint.all.sample
    end

    def test_selling_region
      assert(@endpoint.selling_region)
    end

    def test_host
      assert(@endpoint.host)
    end

    def test_production
      assert_kind_of(URI::HTTPS, @endpoint.production)
    end

    def test_sandbox
      assert_kind_of(URI::HTTPS, @endpoint.sandbox)
      assert_includes(@endpoint.sandbox.host, "sandbox")
    end

    def test_find_by_selling_region
      selling_region = @endpoint.selling_region
      endpoint = Endpoint.find_by_selling_region(selling_region)

      assert_equal(selling_region, endpoint.selling_region)
    end

    def test_unknown_aws_endpoint
      assert_raises(ArgumentError) do
        Endpoint.find("ap-south-2")
      end
    end

    def test_unknown_selling_region
      assert_raises(ArgumentError) do
        Endpoint.find_by_selling_region("Middle Earth")
      end
    end
  end
end
