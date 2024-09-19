# frozen_string_literal: true

require "helper"
require "peddler/region"

module Peddler
  class RegionTest < Minitest::Test
    def test_valid_regions
      Region::ENDPOINTS.each do |name, endpoint|
        region = Region.new(name)

        assert_equal(name, region.name)
        assert_equal(endpoint, region.endpoint)
      end
    end

    def test_sandbox_endpoint
      region = Region.new("us-east-1")

      assert_includes(region.sandbox_endpoint, "sandbox")
    end

    def test_unknown_region
      assert_raises(Region::UnknownRegion) do
        Region.new("invalid").endpoint
      end
    end
  end
end
