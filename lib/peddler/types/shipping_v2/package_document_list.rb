# frozen_string_literal: true

require "peddler/types/shipping_v2/package_document"

module Peddler
  module Types
    module ShippingV2
      # A list of documents related to a package.
      class PackageDocumentList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| PackageDocument.parse(item) })
          end
        end
      end
    end
  end
end
