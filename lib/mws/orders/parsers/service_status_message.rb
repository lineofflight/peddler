require 'peddler/parsers/model'

module MWS
  module Orders
    module Parsers
      class ServiceStatusMessage < ::Peddler::Parsers::Model
        value :locale do
          text_at_xpath('Locale')
        end

        value :text do
          text_at_xpath('Text')
        end
      end
    end
  end
end
