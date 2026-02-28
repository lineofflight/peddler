# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      PostContentDocumentASINRelationsRequest = Structure.new do
        # @return [Array<Asin>]
        attribute(:asin_set, Array, null: false, from: "asinSet")
      end
    end
  end
end
