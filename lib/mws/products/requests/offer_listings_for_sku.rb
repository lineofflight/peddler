require 'mws/products/parsers/offer_listings_for_sku'
require 'peddler/request'

module MWS
  module Products
    module Requests
      class OfferListingsForSKU < ::Peddler::Request
        def get_lowest(*seller_skus)
          options = seller_skus.last.is_a?(Hash) ? seller_skus.pop : {}
          options[:marketplace_id] ||= client.marketplace_id
          parameters('GetLowestOfferListingsForSKU')
            .update(seller_sku_list: seller_skus)
            .update(options)
            .timestamp!
            .format_structured_lists!(skip: [:marketplace_id])
            .camelize_keys!

          execute
        end
      end
    end
  end
end
