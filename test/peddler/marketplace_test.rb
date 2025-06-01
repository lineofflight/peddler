# frozen_string_literal: true

require "helper"
require "peddler/marketplace"

module Peddler
  class MarketplaceTest < Minitest::Test
    def setup
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
        Marketplace.find("FOO")
      end
    end

    def test_id_class_method
      assert(Marketplace.id(country_code))
    end

    def test_id_gb
      assert_equal("A1F83G8C2ARO7P", Marketplace.id("GB"))
    end

    def test_ids
      assert(Marketplace.ids(*MARKETPLACE_IDS.keys))
    end

    def test_all
      assert(Marketplace.all)
    end

    def test_to_str
      assert_equal(@marketplace.id, @marketplace.to_str)
    end

    def test_dynamic_shorthand_methods
      assert_equal("US", Marketplace.us.country_code)
      assert_equal("GB", Marketplace.gb.country_code)
    end

    private

    def country_code
      MARKETPLACE_IDS.keys.sample
    end
  end
end
