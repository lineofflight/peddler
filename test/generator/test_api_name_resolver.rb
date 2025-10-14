# frozen_string_literal: true

require "helper"
require "generator/resolvers/api_name_resolver"

module Generator
  class TestAPINameResolver < Minitest::Test
    def test_directory_based_naming
      file = "selling-partner-api-models/models/catalog-items-api-model/catalogItems_2022-04-01.json"
      resolver = APINameResolver.new(file)

      assert_equal("catalog_items", resolver.name)
    end

    def test_directory_based_naming_strips_model_suffix
      file = "selling-partner-api-models/models/amazon-warehousing-and-distribution-model/awd_2024-05-09.json"
      resolver = APINameResolver.new(file)

      assert_equal("amazon_warehousing_and_distribution", resolver.name)
    end

    def test_filename_based_naming_for_external_fulfillment
      files = [
        "selling-partner-api-models/models/external-fulfillment/externalFulfillmentInventory_2024-09-11.json",
        "selling-partner-api-models/models/external-fulfillment/externalFulfillmentReturns_2024-09-11.json",
        "selling-partner-api-models/models/external-fulfillment/externalFulfillmentShipments_2024-09-11.json",
      ]

      names = files.map { |f| APINameResolver.new(f).name }

      assert_equal(
        [
          "external_fulfillment_inventory",
          "external_fulfillment_returns",
          "external_fulfillment_shipments",
        ],
        names,
      )
    end

    def test_filename_based_naming_for_finances
      files = [
        "selling-partner-api-models/models/finances-api-model/finances_2024-06-19.json",
        "selling-partner-api-models/models/finances-api-model/transfers_2024-06-01.json",
      ]

      names = files.map { |f| APINameResolver.new(f).name }

      assert_equal(["finances", "transfers"], names)
    end

    def test_handles_v_suffix_versions
      file = "selling-partner-api-models/models/catalog-items-api-model/catalogItemsV0.json"
      resolver = APINameResolver.new(file)

      assert_equal("catalog_items", resolver.name)
    end

    def test_handles_hyphenated_dates
      file = "selling-partner-api-models/models/application-integrations-api-model/appIntegrations-2024-04-01.json"
      resolver = APINameResolver.new(file)

      assert_equal("application_integrations", resolver.name)
    end

    def test_validates_no_unmapped_collisions_success
      files = [
        "selling-partner-api-models/models/catalog-items-api-model/catalogItems_2020-12-01.json",
        "selling-partner-api-models/models/catalog-items-api-model/catalogItems_2022-04-01.json",
        "selling-partner-api-models/models/external-fulfillment/externalFulfillmentInventory_2024-09-11.json",
        "selling-partner-api-models/models/external-fulfillment/externalFulfillmentReturns_2024-09-11.json",
      ]

      # Should not raise
      APINameResolver.validate_no_unmapped_collisions!(files)
    end

    def test_validates_no_unmapped_collisions_raises_for_unknown_collision
      files = [
        "selling-partner-api-models/models/new-api-model/newApiA_2024-01-01.json",
        "selling-partner-api-models/models/new-api-model/newApiB_2024-01-01.json",
      ]

      error = assert_raises(RuntimeError) do
        APINameResolver.validate_no_unmapped_collisions!(files)
      end

      assert_match(/Found multiple APIs in directory 'new-api-model'/, error.message)
      assert_match(/Please add this directory to FILENAME_BASED_DIRECTORIES/, error.message)
    end
  end
end
