# frozen_string_literal: true

require "peddler/types/shipping_v2/package_document_detail"

module Peddler
  module Types
    module ShippingV2
      # A list of post-purchase details about a package that will be shipped using a shipping service.
      class PackageDocumentDetailList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| PackageDocumentDetail.parse(item) })
          end
        end
      end
    end
  end
end
