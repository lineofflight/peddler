# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # Input for set appointment fulfillment data operation.
      SetAppointmentFulfillmentDataRequest = Structure.new do
        # @return [Array<AppointmentResource>] Resources involved in appointment fulfillment.
        attribute?(:appointment_resources, [AppointmentResource], from: "appointmentResources")

        # @return [DateTimeRange] The range of time when the technician is expected to arrive at the fulfillment
        # location.
        attribute?(:estimated_arrival_time, DateTimeRange, from: "estimatedArrivalTime")

        # @return [Array<FulfillmentDocument>] Documents specific to appointment fulfillment.
        attribute?(:fulfillment_documents, [FulfillmentDocument], from: "fulfillmentDocuments")

        # @return [FulfillmentTime] Input appointment time details.
        attribute?(:fulfillment_time, FulfillmentTime, from: "fulfillmentTime")
      end
    end
  end
end
