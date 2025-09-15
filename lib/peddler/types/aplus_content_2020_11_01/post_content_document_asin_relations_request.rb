# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module AplusContent20201101
      PostContentDocumentAsinRelationsRequest = Structure.new do
        # @return [Array<Asin>]
        attribute(:asin_set, Array, from: "asinSet")
      end
    end
  end
end
