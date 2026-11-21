# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for third party application integrations.
    #
    # With the AppIntegrations API v2024-04-01, you can send notifications to Amazon Selling Partners and display the
    # notifications in Seller Central.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/application-integrations-api-model/appIntegrations-2024-04-01.json
    module ApplicationIntegrations20240401
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "application_integrations_2024_04_01.create_notification" => -> { CreateNotificationResponse },
      })
    end
  end
end
