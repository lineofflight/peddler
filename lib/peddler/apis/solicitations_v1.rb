# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Solicitations
    #
    # With the Solicitations API you can build applications that send non-critical solicitations to buyers. You can get
    # a list of solicitation types that are available for an order that you specify, then call an operation that sends a
    # solicitation to the buyer for that order. Buyers cannot respond to solicitations sent by this API, and these
    # solicitations do not appear in the Messaging section of Seller Central or in the recipient's Message Center. The
    # Solicitations API returns responses that are formed according to the
    # {https://tools.ietf.org/html/draft-kelly-json-hal-08 JSON Hypertext Application Language} (HAL) standard.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/solicitations-api-model/solicitations.json
    module SolicitationsV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "solicitations_v1.create_product_review_and_seller_feedback_solicitation" => -> { CreateProductReviewAndSellerFeedbackSolicitationResponse },
        "solicitations_v1.get_solicitation_actions_for_order" => -> { GetSolicitationActionsForOrderResponse },
      })
    end
  end
end
