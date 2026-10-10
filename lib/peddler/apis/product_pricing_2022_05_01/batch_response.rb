# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # The common properties for responses to individual requests within a batch.
      BatchResponse = Structure.new do
        attribute(:headers, Hash, null: false)

        attribute(:status, HttpStatusLine, null: false)
      end
    end
  end
end
