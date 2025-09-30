# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # The details of the products the vendor has configured as customizable.
      BuyerCustomizedInfoDetail = Structure.new do
        # @return [String] A [Base 64](https://datatracker.ietf.org/doc/html/rfc4648#section-4) encoded URL using the
        # UTF-8 character set. The URL provides the location of the zip file that specifies the types of customizations
        # or configurations allowed by the vendor, along with types and ranges for the attributes of their products.
        attribute?(:customized_url, String, from: "customizedUrl")
      end
    end
  end
end
