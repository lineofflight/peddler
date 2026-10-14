# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Contains detail codes that provide additional details related to the forward and return leg of the shipment.
      TrackingDetailCodes = Structure.new do
        # @return [Array<DetailCodes>] Contains detail codes that provide additional details related to the forward leg
        #   of the shipment. Known values: `BusinessClosed`, `CustomerUnavailable`, `PaymentNotReady`,
        #   `OtpNotAvailable`, `DeliveryAttempted`, `UnableToAccess`, `UnableToContactRecipient`,
        #   `DeliveredToBehindWheelieBin`, `DeliveredToPorch`, `DeliveredToGarage`, `DeliveredToGarden`,
        #   `DeliveredToGreenhouse`, `DeliveredToMailSlot`, `DeliveredToMailRoom`, `DeliveredToNeighbor`,
        #   `DeliveredToRearDoor`, `DeliveredToReceptionist`, `DeliveredToShed`, `DeliveredWithOTP`, `Signed`,
        #   `Damaged`, `IncorrectItems`, `NotRequired`, `Rejected`, `RejectedByRecipientWithVerification`,
        #   `CancelledByRecipient`, `AddressNotFound`, `HazmatShipment`, `Undeliverable`, `ArrivedAtLocalFacility`.
        attribute(:forward, Array, null: false)

        # @return [Array<DetailCodes>] Contains detail codes that provide additional details related to the return leg
        #   of the shipment. Known values: `BusinessClosed`, `CustomerUnavailable`, `PaymentNotReady`,
        #   `OtpNotAvailable`, `DeliveryAttempted`, `UnableToAccess`, `UnableToContactRecipient`,
        #   `DeliveredToBehindWheelieBin`, `DeliveredToPorch`, `DeliveredToGarage`, `DeliveredToGarden`,
        #   `DeliveredToGreenhouse`, `DeliveredToMailSlot`, `DeliveredToMailRoom`, `DeliveredToNeighbor`,
        #   `DeliveredToRearDoor`, `DeliveredToReceptionist`, `DeliveredToShed`, `DeliveredWithOTP`, `Signed`,
        #   `Damaged`, `IncorrectItems`, `NotRequired`, `Rejected`, `RejectedByRecipientWithVerification`,
        #   `CancelledByRecipient`, `AddressNotFound`, `HazmatShipment`, `Undeliverable`, `ArrivedAtLocalFacility`.
        attribute(:returns, Array, null: false)
      end
    end
  end
end
