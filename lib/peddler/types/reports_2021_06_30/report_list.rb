# frozen_string_literal: true

require "peddler/types/reports_2021_06_30/report"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module Reports20210630
      # A list of reports.
      class ReportList < Array
        class << self
          def parse(array)
            new(array.map { |item| Report.parse(item) })
          end
        end
      end
    end
  end
end
