# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/scope_of_work"
require "peddler/types/services_v1/seller"
require "peddler/types/services_v1/service_job_provider"
require "peddler/types/services_v1/appointment_time"
require "peddler/types/services_v1/appointment"
require "peddler/types/services_v1/buyer"
require "peddler/types/services_v1/associated_item"
require "peddler/types/services_v1/service_location"

module Peddler
  module Types
    module ServicesV1
      # The job details of a service.
      ServiceJob = Structure.new do
        # @return [String] The date and time of the creation of the job in ISO 8601 format.
        attribute(:create_time, String, from: "createTime")

        # @return [String] The service job identifier.
        attribute(:service_job_id, String, from: "serviceJobId")

        # @return [String] The status of the service job.
        attribute(:service_job_status, String, from: "serviceJobStatus")

        # @return [ScopeOfWork] The scope of work for the order.
        attribute(:scope_of_work, ScopeOfWork, from: "scopeOfWork")

        # @return [Seller] Information about the seller of the service job.
        attribute(:seller, Seller)

        # @return [ServiceJobProvider] Information about the service job provider.
        attribute(:service_job_provider, ServiceJobProvider, from: "serviceJobProvider")

        # @return [Array<AppointmentTime>] A list of appointment windows preferred by the buyer. Included only if the
        # buyer selected appointment windows when creating the order.
        attribute(:preferred_appointment_times, [AppointmentTime], from: "preferredAppointmentTimes")

        # @return [Array<Appointment>] A list of appointments.
        attribute(:appointments, [Appointment])

        # @return [String] The Amazon-defined identifier for an order placed by the buyer in 3-7-7 format.
        attribute(:service_order_id, String, from: "serviceOrderId")

        # @return [String] The marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The Amazon-defined identifier for the region scope.
        attribute(:store_id, String, from: "storeId")

        # @return [Buyer] Information about the buyer.
        attribute(:buyer, Buyer)

        # @return [Array<AssociatedItem>] A list of items associated with the service job.
        attribute(:associated_items, [AssociatedItem], from: "associatedItems")

        # @return [ServiceLocation] Information about the location of the service job.
        attribute(:service_location, ServiceLocation, from: "serviceLocation")
      end
    end
  end
end
