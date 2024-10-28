# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def services_v1(...)
      API::ServicesV1.new(...)
    end
  end

  class API
    # Selling Partner API for Services
    #
    # With the Services API, you can build applications that help service providers get and modify their service orders
    # and manage their resources.
    class ServicesV1 < API
      # Gets details of service job indicated by the provided `serviceJobID`.
      #
      # @note This operation can make a static sandbox call.
      # @param service_job_id [String] A service job identifier.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_service_job_by_service_job_id(service_job_id, rate_limit: 20.0)
        path = "/service/v1/serviceJobs/#{service_job_id}"

        meter(rate_limit).get(path)
      end

      # Cancels the service job indicated by the service job identifier specified.
      #
      # @note This operation can make a static sandbox call.
      # @param service_job_id [String] An Amazon defined service job identifier.
      # @param cancellation_reason_code [String] A cancel reason code that specifies the reason for cancelling a service
      #   job.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_service_job_by_service_job_id(service_job_id, cancellation_reason_code, rate_limit: 5.0)
        path = "/service/v1/serviceJobs/#{service_job_id}/cancellations"
        params = {
          "cancellationReasonCode" => cancellation_reason_code,
        }.compact

        meter(rate_limit).put(path, params:)
      end

      # Completes the service job indicated by the service job identifier specified.
      #
      # @note This operation can make a static sandbox call.
      # @param service_job_id [String] An Amazon defined service job identifier.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def complete_service_job_by_service_job_id(service_job_id, rate_limit: 5.0)
        path = "/service/v1/serviceJobs/#{service_job_id}/completions"

        meter(rate_limit).put(path)
      end

      # Gets service job details for the specified filter query.
      #
      # @note This operation can make a static sandbox call.
      # @param service_order_ids [Array<String>] List of service order ids for the query you want to perform.Max values
      #   supported 20.
      # @param service_job_status [Array<String>] A list of one or more job status by which to filter the list of jobs.
      # @param page_token [String] String returned in the response of your previous request.
      # @param page_size [Integer] A non-negative integer that indicates the maximum number of jobs to return in the
      #   list, Value must be 1 - 20. Default 20.
      # @param sort_field [String] Sort fields on which you want to sort the output.
      # @param sort_order [String] Sort order for the query you want to perform.
      # @param created_after [String] A date used for selecting jobs created at or after a specified time. Must be in
      #   ISO 8601 format. Required if `LastUpdatedAfter` is not specified. Specifying both `CreatedAfter` and
      #   `LastUpdatedAfter` returns an error.
      # @param created_before [String] A date used for selecting jobs created at or before a specified time. Must be in
      #   ISO 8601 format.
      # @param last_updated_after [String] A date used for selecting jobs updated at or after a specified time. Must be
      #   in ISO 8601 format. Required if `createdAfter` is not specified. Specifying both `CreatedAfter` and
      #   `LastUpdatedAfter` returns an error.
      # @param last_updated_before [String] A date used for selecting jobs updated at or before a specified time. Must
      #   be in ISO 8601 format.
      # @param schedule_start_date [String] A date used for filtering jobs schedules at or after a specified time. Must
      #   be in ISO 8601 format. Schedule end date should not be earlier than schedule start date.
      # @param schedule_end_date [String] A date used for filtering jobs schedules at or before a specified time. Must
      #   be in ISO 8601 format. Schedule end date should not be earlier than schedule start date.
      # @param marketplace_ids [Array<String>] Used to select jobs that were placed in the specified marketplaces.
      # @param asins [Array<String>] List of Amazon Standard Identification Numbers (ASIN) of the items. Max values
      #   supported is 20.
      # @param required_skills [Array<String>] A defined set of related knowledge, skills, experience, tools, materials,
      #   and work processes common to service delivery for a set of products and/or service scenarios. Max values
      #   supported is 20.
      # @param store_ids [Array<String>] List of Amazon-defined identifiers for the region scope. Max values supported
      #   is 50.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_service_jobs(marketplace_ids, service_order_ids: nil, service_job_status: nil, page_token: nil,
        page_size: 20, sort_field: nil, sort_order: nil, created_after: nil, created_before: nil,
        last_updated_after: nil, last_updated_before: nil, schedule_start_date: nil, schedule_end_date: nil, asins: nil,
        required_skills: nil, store_ids: nil, rate_limit: 10.0)
        path = "/service/v1/serviceJobs"
        params = {
          "serviceOrderIds" => service_order_ids,
          "serviceJobStatus" => service_job_status,
          "pageToken" => page_token,
          "pageSize" => page_size,
          "sortField" => sort_field,
          "sortOrder" => sort_order,
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "lastUpdatedAfter" => last_updated_after,
          "lastUpdatedBefore" => last_updated_before,
          "scheduleStartDate" => schedule_start_date,
          "scheduleEndDate" => schedule_end_date,
          "marketplaceIds" => marketplace_ids,
          "asins" => asins,
          "requiredSkills" => required_skills,
          "storeIds" => store_ids,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Adds an appointment to the service job indicated by the service job identifier specified.
      #
      # @note This operation can make a static sandbox call.
      # @param service_job_id [String] An Amazon defined service job identifier.
      # @param body [Hash] Add appointment operation input details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def add_appointment_for_service_job_by_service_job_id(service_job_id, body, rate_limit: 5.0)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointments"

        meter(rate_limit).post(path, body:)
      end

      # Reschedules an appointment for the service job indicated by the service job identifier specified.
      #
      # @note This operation can make a static sandbox call.
      # @param service_job_id [String] An Amazon defined service job identifier.
      # @param appointment_id [String] An existing appointment identifier for the Service Job.
      # @param body [Hash] Reschedule appointment operation input details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def reschedule_appointment_for_service_job_by_service_job_id(service_job_id, appointment_id, body,
        rate_limit: 5.0)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointments/#{appointment_id}"

        meter(rate_limit).post(path, body:)
      end

      # Assigns new resource(s) or overwrite/update the existing one(s) to a service job appointment.
      #
      # @note This operation can make a static sandbox call.
      # @param service_job_id [String] An Amazon-defined service job identifier. Get this value by calling the
      #   `getServiceJobs` operation of the Services API.
      # @param appointment_id [String] An Amazon-defined identifier of active service job appointment.
      # @param body [Hash]
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def assign_appointment_resources(service_job_id, appointment_id, body, rate_limit: 1.0)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointments/#{appointment_id}/resources"

        meter(rate_limit).put(path, body:)
      end

      # Updates the appointment fulfillment data related to a given `jobID` and `appointmentID`.
      #
      # @note This operation can make a static sandbox call.
      # @param service_job_id [String] An Amazon-defined service job identifier. Get this value by calling the
      #   `getServiceJobs` operation of the Services API.
      # @param appointment_id [String] An Amazon-defined identifier of active service job appointment.
      # @param body [Hash] Appointment fulfillment data collection details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def set_appointment_fulfillment_data(service_job_id, appointment_id, body, rate_limit: 5.0)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointments/#{appointment_id}/fulfillment"

        meter(rate_limit).put(path, body:)
      end

      # Provides capacity slots in a format similar to availability records.
      #
      # @note This operation can make a static sandbox call.
      # @param resource_id [String] Resource Identifier.
      # @param body [Hash] Request body.
      # @param marketplace_ids [Array<String>] An identifier for the marketplace in which the resource operates.
      # @param next_page_token [String] Next page token returned in the response of your previous request.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_range_slot_capacity(resource_id, body, marketplace_ids, next_page_token: nil, rate_limit: 5.0)
        path = "/service/v1/serviceResources/#{resource_id}/capacity/range"
        params = {
          "marketplaceIds" => marketplace_ids,
          "nextPageToken" => next_page_token,
        }.compact

        meter(rate_limit).post(path, body:, params:)
      end

      # Provides capacity in fixed-size slots.
      #
      # @note This operation can make a static sandbox call.
      # @param resource_id [String] Resource Identifier.
      # @param body [Hash] Request body.
      # @param marketplace_ids [Array<String>] An identifier for the marketplace in which the resource operates.
      # @param next_page_token [String] Next page token returned in the response of your previous request.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_fixed_slot_capacity(resource_id, body, marketplace_ids, next_page_token: nil, rate_limit: 5.0)
        path = "/service/v1/serviceResources/#{resource_id}/capacity/fixed"
        params = {
          "marketplaceIds" => marketplace_ids,
          "nextPageToken" => next_page_token,
        }.compact

        meter(rate_limit).post(path, body:, params:)
      end

      # Update the schedule of the given resource.
      #
      # @note This operation can make a static sandbox call.
      # @param resource_id [String] Resource (store) Identifier
      # @param body [Hash] Schedule details
      # @param marketplace_ids [Array<String>] An identifier for the marketplace in which the resource operates.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_schedule(resource_id, body, marketplace_ids, rate_limit: 5.0)
        path = "/service/v1/serviceResources/#{resource_id}/schedules"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        meter(rate_limit).put(path, body:, params:)
      end

      # Create a reservation.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Reservation details
      # @param marketplace_ids [Array<String>] An identifier for the marketplace in which the resource operates.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_reservation(body, marketplace_ids, rate_limit: 5.0)
        path = "/service/v1/reservation"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        meter(rate_limit).post(path, body:, params:)
      end

      # Update a reservation.
      #
      # @note This operation can make a static sandbox call.
      # @param reservation_id [String] Reservation Identifier
      # @param body [Hash] Reservation details
      # @param marketplace_ids [Array<String>] An identifier for the marketplace in which the resource operates.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def update_reservation(reservation_id, body, marketplace_ids, rate_limit: 5.0)
        path = "/service/v1/reservation/#{reservation_id}"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        meter(rate_limit).put(path, body:, params:)
      end

      # Cancel a reservation.
      #
      # @note This operation can make a static sandbox call.
      # @param reservation_id [String] Reservation Identifier
      # @param marketplace_ids [Array<String>] An identifier for the marketplace in which the resource operates.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def cancel_reservation(reservation_id, marketplace_ids, rate_limit: 5.0)
        path = "/service/v1/reservation/#{reservation_id}"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        meter(rate_limit).delete(path, params:)
      end

      # Gets appointment slots for the service associated with the service job id specified.
      #
      # @note This operation can make a static sandbox call.
      # @param service_job_id [String] A service job identifier to retrive appointment slots for associated service.
      # @param marketplace_ids [Array<String>] An identifier for the marketplace in which the resource operates.
      # @param start_time [String] A time from which the appointment slots will be retrieved. The specified time must be
      #   in ISO 8601 format. If `startTime` is provided, `endTime` should also be provided. Default value is as per
      #   business configuration.
      # @param end_time [String] A time up to which the appointment slots will be retrieved. The specified time must be
      #   in ISO 8601 format. If `endTime` is provided, `startTime` should also be provided. Default value is as per
      #   business configuration. Maximum range of appointment slots can be 90 days.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_appointmment_slots_by_job_id(service_job_id, marketplace_ids, start_time: nil, end_time: nil,
        rate_limit: 5.0)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointmentSlots"
        params = {
          "marketplaceIds" => marketplace_ids,
          "startTime" => start_time,
          "endTime" => end_time,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Gets appointment slots as per the service context specified.
      #
      # @note This operation can make a static sandbox call.
      # @param asin [String] ASIN associated with the service.
      # @param store_id [String] Store identifier defining the region scope to retrive appointment slots.
      # @param marketplace_ids [Array<String>] An identifier for the marketplace for which appointment slots are queried
      # @param start_time [String] A time from which the appointment slots will be retrieved. The specified time must be
      #   in ISO 8601 format. If `startTime` is provided, `endTime` should also be provided. Default value is as per
      #   business configuration.
      # @param end_time [String] A time up to which the appointment slots will be retrieved. The specified time must be
      #   in ISO 8601 format. If `endTime` is provided, `startTime` should also be provided. Default value is as per
      #   business configuration. Maximum range of appointment slots can be 90 days.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_appointment_slots(asin, store_id, marketplace_ids, start_time: nil, end_time: nil, rate_limit: 20.0)
        path = "/service/v1/appointmentSlots"
        params = {
          "asin" => asin,
          "storeId" => store_id,
          "marketplaceIds" => marketplace_ids,
          "startTime" => start_time,
          "endTime" => end_time,
        }.compact

        meter(rate_limit).get(path, params:)
      end

      # Creates an upload destination.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] Upload document operation input details.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_service_document_upload_destination(body, rate_limit: 5.0)
        path = "/service/v1/documents"

        meter(rate_limit).post(path, body:)
      end
    end
  end
end
