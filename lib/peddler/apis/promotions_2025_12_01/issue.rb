# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Promotions20251201
      # Issue information with code, message, and severity.
      Issue = Structure.new do
        # Issue code identifier.
        attribute(:code, String, null: false)

        # Issue description.
        attribute(:message, String, null: false)

        # Issue severity level. Known values: `ERROR`, `WARNING`.
        attribute(:severity, String, null: false)
      end
    end
  end
end
