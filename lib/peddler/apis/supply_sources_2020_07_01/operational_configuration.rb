# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The operational configuration of `supplySources`.
      OperationalConfiguration = Structure.new do
        attribute?(:contact_details, ContactDetails, from: "contactDetails")

        attribute?(:handling_time, Duration, from: "handlingTime")

        attribute?(:operating_hours_by_day, OperatingHoursByDay, from: "operatingHoursByDay")

        attribute?(:throughput_config, ThroughputConfig, from: "throughputConfig")
      end
    end
  end
end
