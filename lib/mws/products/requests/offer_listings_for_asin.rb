require 'mws/products/parsers/offer_listings_for_asin'
require 'peddler/request'

module MWS
  module Products
    module Requests
      class OfferListingsForASIN < ::Peddler::Request
        def get_lowest(*asins)
          options = asins.last.is_a?(Hash) ? asins.pop : {}
          options[:marketplace_id] ||= client.marketplace_id
          parameters('GetLowestOfferListingsForASIN')
            .update(asin_list: asins)
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
