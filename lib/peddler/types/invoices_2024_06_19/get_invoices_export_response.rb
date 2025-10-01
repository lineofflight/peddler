# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/invoices_2024_06_19/export"

module Peddler
  module Types
    module Invoices20240619
      # Success.
      GetInvoicesExportResponse = Structure.new do
        # @return [Export]
        attribute?(:export, Export)
      end
    end
  end
end
