# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Messaging
    #
    # With the Messaging API you can build applications that send messages to buyers. You can get a list of message
    # types that are available for an order that you specify, then call an operation that sends a message to the buyer
    # for that order. The Messaging API returns responses that are formed according to the
    # {https://tools.ietf.org/html/draft-kelly-json-hal-08 JSON Hypertext Application Language} (HAL) standard.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/messaging-api-model/messaging.json
    module MessagingV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "messaging_v1.confirm_customization_details" => -> { CreateConfirmCustomizationDetailsResponse },
        "messaging_v1.create_confirm_delivery_details" => -> { CreateConfirmDeliveryDetailsResponse },
        "messaging_v1.create_confirm_order_details" => -> { CreateConfirmOrderDetailsResponse },
        "messaging_v1.create_confirm_service_details" => -> { CreateConfirmServiceDetailsResponse },
        "messaging_v1.create_digital_access_key" => -> { CreateDigitalAccessKeyResponse },
        "messaging_v1.create_legal_disclosure" => -> { CreateLegalDisclosureResponse },
        "messaging_v1.create_unexpected_problem" => -> { CreateUnexpectedProblemResponse },
        "messaging_v1.create_warranty" => -> { CreateWarrantyResponse },
        "messaging_v1.get_attributes" => -> { GetAttributesResponse },
        "messaging_v1.get_messaging_actions_for_order" => -> { GetMessagingActionsForOrderResponse },
        "messaging_v1.send_invoice" => -> { InvoiceResponse },
      })
    end
  end
end
