# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module Finances20240619
      # Additional information related to Payments related transactions.
      PaymentsContext = Structure.new do
        # @return [String] Date of payment made.
        attribute?(:payment_date, String, from: "paymentDate")

        # @return [String] Method of payment made.
        attribute?(:payment_method, String, from: "paymentMethod")

        # @return [String] Reference number of payment made.
        attribute?(:payment_reference, String, from: "paymentReference")

        # @return [String] Type of payment made.
        attribute?(:payment_type, String, from: "paymentType")
      end
    end
  end
end
