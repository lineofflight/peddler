require 'peddler/parsers/model'

module MWS
  module Reports
    module Parsers
      class ReportRequestCount < ::Peddler::Parsers::Model
        value :count do
          integer_at_xpath('Count')
        end
      end
    end
  end
end
