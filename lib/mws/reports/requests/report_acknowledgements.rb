require 'peddler/request'
require 'mws/reports/parsers/report_acknowledgements'

module MWS
  module Reports
    module Requests
      class ReportAcknowledgements < ::Peddler::Request
        def update(acknowledged, *ids)
          parameters('UpdateReportAcknowledgement')
            .update(report_id_list: ids, acknowledged: acknowledged)
            .format_structured_lists!
            .camelize_keys!

          execute
        end

        def acknowledge(*ids)
          update(true, *ids)
        end

        def unacknowledge(*ids)
          update(false, *ids)
        end
      end
    end
  end
end
