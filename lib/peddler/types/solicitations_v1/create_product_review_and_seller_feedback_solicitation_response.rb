# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/solicitations_v1/error"

module Peddler
  module Types
    module SolicitationsV1
      # The response schema for the createProductReviewAndSellerFeedbackSolicitation operation.
      CreateProductReviewAndSellerFeedbackSolicitationResponse = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
