# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Support
    #
    # The Selling Partner API for Support provides programmatic access to information about Selling Partner support.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/support-api-model/support_2025-02-01.json
    module Support20250201
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "support_2025_02_01.get_case" => -> { Case },
        "support_2025_02_01.list_cases" => -> { ListCasesResult },
        "support_2025_02_01.list_contacts" => -> { ListContactsResult },
      })
    end
  end
end
