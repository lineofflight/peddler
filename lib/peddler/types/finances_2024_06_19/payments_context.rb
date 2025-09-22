# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Additional information related to Payments related transactions.
      PaymentsContext = Structure.new do
        # @return [String] Type of payment made.
        attribute(:payment_type, String, from: "paymentType")

        # @return [String] Method of payment made.
        attribute(:payment_method, String, from: "paymentMethod")

        # @return [String] Reference number of payment made.
        attribute(:payment_reference, String, from: "paymentReference")

        # @return [String] Date of payment made.
        attribute(:payment_date, String, from: "paymentDate")
      end
    end
  end
end
