# frozen_string_literal: true

require "helper"
require "peddler/marketplace"

module Peddler
  class MarketplaceTest < Minitest::Test
    def setup
      country_code = MARKETPLACE_IDS.keys.sample
      @marketplace = Marketplace.find(country_code)
    end

    def test_id
      assert(@marketplace.id)
    end

    def test_country_code
      assert(@marketplace.country_code)
    end

    def test_country_name
      assert(@marketplace.country_name)
    end

    def test_selling_region
      assert(@marketplace.selling_region)
    end

    def test_endpoint
      assert(@marketplace.endpoint)
    end

    def test_invalid_country_code
      assert_raises(ArgumentError) do
        Marketplace.new("FOO").id
      end
    end
  end
end
