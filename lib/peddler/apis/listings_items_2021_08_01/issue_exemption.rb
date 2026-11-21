# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ListingsItems20210801
      # The status of the listed enforcement actions. If applicable, includes information about the exemption expiry
      # date.
      IssueExemption = Structure.new do
        # Indicates the current exemption status for the listed enforcement actions. It can take values such as
        # `EXEMPT`, signifying permanent exemption, `EXEMPT_UNTIL_EXPIRY_DATE` indicating temporary exemption until a
        # specified date, or `NOT_EXEMPT` signifying no exemptions, and enforcement actions were already applied.
        attribute(:status, String, null: false)

        # The timestamp, in ISO 8601 format, when the temporary exemption expires and Amazon begins enforcing the listed
        # actions.
        attribute?(:expiry_date, Time, from: "expiryDate")
      end
    end
  end
end
