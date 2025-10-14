# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Invoices20240619
      # Success.
      GetInvoicesExportResponse = Structure.new do
        # @return [Export]
        attribute?(:export, Export)
      end
    end
  end
end
