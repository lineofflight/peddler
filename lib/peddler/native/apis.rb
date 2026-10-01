# frozen_string_literal: true

# Manual facades for the 2-operation milestone; generation is later expansion work.
module Peddler
  module Native
    class CatalogItems20220401
      def initialize(engine)
        @engine = engine
      end

      def get_catalog_item(asin:, marketplace_ids:, included_data: ["summaries"], locale: nil)
        arguments = JSON.generate(asin: asin, marketplace_ids: marketplace_ids, included_data: included_data, locale: locale)
        status, headers, body = @engine.operation("catalog_items_2022_04_01.get_catalog_item", arguments)
        Response.new(status, headers, body)
      end
    end

    class ListingsItems20210801
      def initialize(engine)
        @engine = engine
      end

      def patch_listings_item(seller_id:, sku:, marketplace_ids:, body:, included_data: ["issues"], mode: nil, issue_locale: nil)
        arguments = JSON.generate(seller_id: seller_id, sku: sku, marketplace_ids: marketplace_ids, body: body,
          included_data: included_data, mode: mode, issue_locale: issue_locale)
        status, headers, response_body = @engine.operation("listings_items_2021_08_01.patch_listings_item", arguments)
        Response.new(status, headers, response_body)
      end
    end
  end

  class Client
    def catalog_items_2022_04_01
      Native::CatalogItems20220401.new(@engine)
    end

    def listings_items_2021_08_01
      Native::ListingsItems20210801.new(@engine)
    end
  end
end
