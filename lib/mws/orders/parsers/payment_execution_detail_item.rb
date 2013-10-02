require 'peddler/parsers/model'

module MWS
  module Orders
    module Parsers
      class PaymentExecutionDetailItem < ::Peddler::Parsers::Model
        value :payment do
          money_at_xpath('Payment')
        end

        value :payment_method do
          text_at_xpath('PaymentMethod')
        end
      end
    end
  end
end
