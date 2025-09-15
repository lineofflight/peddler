# frozen_string_literal: true

require "peddler/types/services_v1/date_time_range"
require "peddler/types/services_v1/fulfillment_time"
require "peddler/types/services_v1/appointment_resource"
require "peddler/types/services_v1/fulfillment_document"

module Peddler
  module Types
    module ServicesV1
      # Input for set appointment fulfillment data operation.
      SetAppointmentFulfillmentDataRequest = Structure.new do
        # @return [DateTimeRange] The range of time when the technician is expected to arrive at the fulfillment
        # location.
        attribute(:estimated_arrival_time, DateTimeRange, from: "estimatedArrivalTime")

        # @return [FulfillmentTime] Input appointment time details.
        attribute(:fulfillment_time, FulfillmentTime, from: "fulfillmentTime")

        # @return [Array<AppointmentResource>] Resources involved in appointment fulfillment.
        attribute(:appointment_resources, [AppointmentResource], from: "appointmentResources")

        # @return [Array<FulfillmentDocument>] Documents specific to appointment fulfillment.
        attribute(:fulfillment_documents, [FulfillmentDocument], from: "fulfillmentDocuments")
      end
    end
  end
end
