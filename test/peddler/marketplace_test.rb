# frozen_string_literal: true

require "helper"

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

    def test_to_json_is_its_id_at_any_depth
      id = @marketplace.id

      assert_equal(%("#{id}"), @marketplace.to_json)
      assert_equal(%(["#{id}"]), JSON.generate([@marketplace]))
      assert_equal(%({"a":[{"b":"#{id}"}]}), JSON.generate({ "a" => [{ "b" => @marketplace }] }))
    end

    def test_dynamic_shorthand_methods
      assert_equal("US", Marketplace.us.country_code)
      assert_equal("GB", Marketplace.gb.country_code)
    end

    # The finders are defined in a loop, so their signatures are kept by hand.
    def test_every_finder_has_a_signature
      signatures = File.read(File.expand_path("../../sig/peddler/marketplace.rbs", __dir__))
      finders = [*MARKETPLACE_IDS.keys, "GB"].map(&:downcase)

      assert_equal(finders.sort, signatures.scan(/def self\.(\w\w): \(\) -> Marketplace/).flatten.sort)
      assert_equal(finders.map(&:upcase), finders.map { |finder| Marketplace.public_send(finder).country_code })
    end

    def test_marketplace_ids_ractor_shareable
      assert(Ractor.shareable?(MARKETPLACE_IDS))
    end

    private

    def country_code
      MARKETPLACE_IDS.keys.sample
    end
  end
end
