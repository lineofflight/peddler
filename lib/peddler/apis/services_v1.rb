# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for Services
    #
    # With the Services API, you can build applications that help service providers get and modify their service orders
    # and manage their resources.
    #
    # https://github.com/amzn/selling-partner-api-models/blob/main/models/services-api-model/services.json
    module ServicesV1
      # Typed models of successful responses, by native operation key. Shareable, so that any Ractor can read it.
      PARSERS = Ractor.make_shareable({
        "services_v1.add_appointment_for_service_job_by_service_job_id" => -> { SetAppointmentResponse },
        "services_v1.assign_appointment_resources" => -> { AssignAppointmentResourcesResponse },
        "services_v1.cancel_reservation" => -> { CancelReservationResponse },
        "services_v1.cancel_service_job_by_service_job_id" => -> { CancelServiceJobByServiceJobIdResponse },
        "services_v1.complete_service_job_by_service_job_id" => -> { CompleteServiceJobByServiceJobIdResponse },
        "services_v1.create_reservation" => -> { CreateReservationResponse },
        "services_v1.create_service_document_upload_destination" => -> { CreateServiceDocumentUploadDestination },
        "services_v1.get_appointment_slots" => -> { GetAppointmentSlotsResponse },
        "services_v1.get_appointmment_slots_by_job_id" => -> { GetAppointmentSlotsResponse },
        "services_v1.get_fixed_slot_capacity" => -> { FixedSlotCapacity },
        "services_v1.get_range_slot_capacity" => -> { RangeSlotCapacity },
        "services_v1.get_service_job_by_service_job_id" => -> { GetServiceJobByServiceJobIdResponse },
        "services_v1.get_service_jobs" => -> { GetServiceJobsResponse },
        "services_v1.reschedule_appointment_for_service_job_by_service_job_id" => -> { SetAppointmentResponse },
        "services_v1.update_reservation" => -> { UpdateReservationResponse },
        "services_v1.update_schedule" => -> { UpdateScheduleResponse },
      })
    end
  end
end
