# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Services
    #
    # With the Services API, you can build applications that help service providers get and modify their service orders
    # and manage their resources.
    class ServicesV1 < API
      # Gets details of service job indicated by the provided `serviceJobID`.
      #
      # @param [String] service_job_id A service job identifier.
      # @return [Hash] The API response
      def get_service_job_by_service_job_id(service_job_id)
        path = "/service/v1/serviceJobs/#{service_job_id}"

        rate_limit(0.05).get(path)
      end

      # Cancels the service job indicated by the service job identifier specified.
      #
      # @param [String] service_job_id An Amazon defined service job identifier.
      # @param [String] cancellation_reason_code A cancel reason code that specifies the reason for cancelling a service
      #   job.
      # @return [Hash] The API response
      def cancel_service_job_by_service_job_id(service_job_id, cancellation_reason_code)
        path = "/service/v1/serviceJobs/#{service_job_id}/cancellations"
        params = {
          "cancellationReasonCode" => cancellation_reason_code,
        }.compact

        rate_limit(0.2).put(path, params:)
      end

      # Completes the service job indicated by the service job identifier specified.
      #
      # @param [String] service_job_id An Amazon defined service job identifier.
      # @return [Hash] The API response
      def complete_service_job_by_service_job_id(service_job_id)
        path = "/service/v1/serviceJobs/#{service_job_id}/completions"

        rate_limit(0.2).put(path)
      end

      # Gets service job details for the specified filter query.
      #
      # @param [Array<String>] service_order_ids List of service order ids for the query you want to perform.Max values
      #   supported 20.
      # @param [Array<String>] service_job_status A list of one or more job status by which to filter the list of jobs.
      # @param [String] page_token String returned in the response of your previous request.
      # @param [Integer] page_size A non-negative integer that indicates the maximum number of jobs to return in the
      #   list, Value must be 1 - 20. Default 20.
      # @param [String] sort_field Sort fields on which you want to sort the output.
      # @param [String] sort_order Sort order for the query you want to perform.
      # @param [String] created_after A date used for selecting jobs created at or after a specified time. Must be in
      #   ISO 8601 format. Required if `LastUpdatedAfter` is not specified. Specifying both `CreatedAfter` and
      #   `LastUpdatedAfter` returns an error.
      # @param [String] created_before A date used for selecting jobs created at or before a specified time. Must be in
      #   ISO 8601 format.
      # @param [String] last_updated_after A date used for selecting jobs updated at or after a specified time. Must be
      #   in ISO 8601 format. Required if `createdAfter` is not specified. Specifying both `CreatedAfter` and
      #   `LastUpdatedAfter` returns an error.
      # @param [String] last_updated_before A date used for selecting jobs updated at or before a specified time. Must
      #   be in ISO 8601 format.
      # @param [String] schedule_start_date A date used for filtering jobs schedules at or after a specified time. Must
      #   be in ISO 8601 format. Schedule end date should not be earlier than schedule start date.
      # @param [String] schedule_end_date A date used for filtering jobs schedules at or before a specified time. Must
      #   be in ISO 8601 format. Schedule end date should not be earlier than schedule start date.
      # @param [Array<String>] marketplace_ids Used to select jobs that were placed in the specified marketplaces.
      # @param [Array<String>] asins List of Amazon Standard Identification Numbers (ASIN) of the items. Max values
      #   supported is 20.
      # @param [Array<String>] required_skills A defined set of related knowledge, skills, experience, tools, materials,
      #   and work processes common to service delivery for a set of products and/or service scenarios. Max values
      #   supported is 20.
      # @param [Array<String>] store_ids List of Amazon-defined identifiers for the region scope. Max values supported
      #   is 50.
      # @return [Hash] The API response
      def get_service_jobs(
        marketplace_ids, service_order_ids: nil, service_job_status: nil, page_token: nil, page_size: nil,
        sort_field: nil, sort_order: nil, created_after: nil, created_before: nil, last_updated_after: nil,
        last_updated_before: nil, schedule_start_date: nil, schedule_end_date: nil, asins: nil, required_skills: nil,
        store_ids: nil
      )
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

        rate_limit(0.1).get(path, params:)
      end

      # Adds an appointment to the service job indicated by the service job identifier specified.
      #
      # @param [String] service_job_id An Amazon defined service job identifier.
      # @param [Hash] body Add appointment operation input details.
      # @return [Hash] The API response
      def add_appointment_for_service_job_by_service_job_id(service_job_id, body)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointments"
        body = body

        rate_limit(0.2).post(path, body:)
      end

      # Reschedules an appointment for the service job indicated by the service job identifier specified.
      #
      # @param [String] service_job_id An Amazon defined service job identifier.
      # @param [String] appointment_id An existing appointment identifier for the Service Job.
      # @param [Hash] body Reschedule appointment operation input details.
      # @return [Hash] The API response
      def reschedule_appointment_for_service_job_by_service_job_id(service_job_id, appointment_id, body)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointments/#{appointment_id}"
        body = body

        rate_limit(0.2).post(path, body:)
      end

      # Assigns new resource(s) or overwrite/update the existing one(s) to a service job appointment.
      #
      # @param [String] service_job_id An Amazon-defined service job identifier. Get this value by calling the
      #   `getServiceJobs` operation of the Services API.
      # @param [String] appointment_id An Amazon-defined identifier of active service job appointment.
      # @param [Hash] body
      # @return [Hash] The API response
      def assign_appointment_resources(service_job_id, appointment_id, body)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointments/#{appointment_id}/resources"
        body = body

        rate_limit(1.0).put(path, body:)
      end

      # Updates the appointment fulfillment data related to a given `jobID` and `appointmentID`.
      #
      # @param [String] service_job_id An Amazon-defined service job identifier. Get this value by calling the
      #   `getServiceJobs` operation of the Services API.
      # @param [String] appointment_id An Amazon-defined identifier of active service job appointment.
      # @param [Hash] body Appointment fulfillment data collection details.
      # @return [Hash] The API response
      def set_appointment_fulfillment_data(service_job_id, appointment_id, body)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointments/#{appointment_id}/fulfillment"
        body = body

        rate_limit(0.2).put(path, body:)
      end

      # Provides capacity slots in a format similar to availability records.
      #
      # @param [String] resource_id Resource Identifier.
      # @param [Hash] body Request body.
      # @param [Array<String>] marketplace_ids An identifier for the marketplace in which the resource operates.
      # @param [String] next_page_token Next page token returned in the response of your previous request.
      # @return [Hash] The API response
      def get_range_slot_capacity(resource_id, body, marketplace_ids, next_page_token: nil)
        path = "/service/v1/serviceResources/#{resource_id}/capacity/range"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
          "nextPageToken" => next_page_token,
        }.compact

        rate_limit(0.2).post(path, body:, params:)
      end

      # Provides capacity in fixed-size slots.
      #
      # @param [String] resource_id Resource Identifier.
      # @param [Hash] body Request body.
      # @param [Array<String>] marketplace_ids An identifier for the marketplace in which the resource operates.
      # @param [String] next_page_token Next page token returned in the response of your previous request.
      # @return [Hash] The API response
      def get_fixed_slot_capacity(resource_id, body, marketplace_ids, next_page_token: nil)
        path = "/service/v1/serviceResources/#{resource_id}/capacity/fixed"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
          "nextPageToken" => next_page_token,
        }.compact

        rate_limit(0.2).post(path, body:, params:)
      end

      # Update the schedule of the given resource.
      #
      # @param [String] resource_id Resource (store) Identifier
      # @param [Hash] body Schedule details
      # @param [Array<String>] marketplace_ids An identifier for the marketplace in which the resource operates.
      # @return [Hash] The API response
      def update_schedule(resource_id, body, marketplace_ids)
        path = "/service/v1/serviceResources/#{resource_id}/schedules"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(0.2).put(path, body:, params:)
      end

      # Create a reservation.
      #
      # @param [Hash] body Reservation details
      # @param [Array<String>] marketplace_ids An identifier for the marketplace in which the resource operates.
      # @return [Hash] The API response
      def create_reservation(body, marketplace_ids)
        path = "/service/v1/reservation"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(0.2).post(path, body:, params:)
      end

      # Update a reservation.
      #
      # @param [String] reservation_id Reservation Identifier
      # @param [Hash] body Reservation details
      # @param [Array<String>] marketplace_ids An identifier for the marketplace in which the resource operates.
      # @return [Hash] The API response
      def update_reservation(reservation_id, body, marketplace_ids)
        path = "/service/v1/reservation/#{reservation_id}"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(0.2).put(path, body:, params:)
      end

      # Cancel a reservation.
      #
      # @param [String] reservation_id Reservation Identifier
      # @param [Array<String>] marketplace_ids An identifier for the marketplace in which the resource operates.
      # @return [Hash] The API response
      def cancel_reservation(reservation_id, marketplace_ids)
        path = "/service/v1/reservation/##{reservation_id}"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(0.2).delete(path, params:)
      end

      # Gets appointment slots for the service associated with the service job id specified.
      #
      # @param [String] service_job_id A service job identifier to retrive appointment slots for associated service.
      # @param [Array<String>] marketplace_ids An identifier for the marketplace in which the resource operates.
      # @param [String] start_time A time from which the appointment slots will be retrieved. The specified time must be
      #   in ISO 8601 format. If `startTime` is provided, `endTime` should also be provided. Default value is as per
      #   business configuration.
      # @param [String] end_time A time up to which the appointment slots will be retrieved. The specified time must be
      #   in ISO 8601 format. If `endTime` is provided, `startTime` should also be provided. Default value is as per
      #   business configuration. Maximum range of appointment slots can be 90 days.
      # @return [Hash] The API response
      def get_appointmment_slots_by_job_id(service_job_id, marketplace_ids, start_time: nil, end_time: nil)
        path = "/service/v1/serviceJobs/#{service_job_id}/appointmentSlots"
        params = {
          "marketplaceIds" => marketplace_ids,
          "startTime" => start_time,
          "endTime" => end_time,
        }.compact

        rate_limit(0.2).get(path, params:)
      end

      # Gets appointment slots as per the service context specified.
      #
      # @param [String] asin ASIN associated with the service.
      # @param [String] store_id Store identifier defining the region scope to retrive appointment slots.
      # @param [Array<String>] marketplace_ids An identifier for the marketplace for which appointment slots are queried
      # @param [String] start_time A time from which the appointment slots will be retrieved. The specified time must be
      #   in ISO 8601 format. If `startTime` is provided, `endTime` should also be provided. Default value is as per
      #   business configuration.
      # @param [String] end_time A time up to which the appointment slots will be retrieved. The specified time must be
      #   in ISO 8601 format. If `endTime` is provided, `startTime` should also be provided. Default value is as per
      #   business configuration. Maximum range of appointment slots can be 90 days.
      # @return [Hash] The API response
      def get_appointment_slots(asin, store_id, marketplace_ids, start_time: nil, end_time: nil)
        path = "/service/v1/appointmentSlots"
        params = {
          "asin" => asin,
          "storeId" => store_id,
          "marketplaceIds" => marketplace_ids,
          "startTime" => start_time,
          "endTime" => end_time,
        }.compact

        rate_limit(0.05).get(path, params:)
      end

      # Creates an upload destination.
      #
      # @param [Hash] body Upload document operation input details.
      # @return [Hash] The API response
      def create_service_document_upload_destination(body)
        path = "/service/v1/documents"
        body = body

        rate_limit(0.2).post(path, body:)
      end
    end
  end
end
