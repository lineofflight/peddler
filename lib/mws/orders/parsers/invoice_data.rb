require 'peddler/parsers/model'

module MWS
  module Orders
    module Parser
      class InvoiceData < ::Peddler::Parsers::Model
        value :invoice_requirement do
          text_at_xpath('InvoiceRequirement')
        end

        value :buyer_selected_invoice_category do
          text_at_xpath('BuyerSelectedInvoiceCategory')
        end

        value :invoice_title do
          text_at_xpath('InvoiceTitle')
        end

        value :invoice_information do
          text_at_xpath('InvoiceInformation')
        end
      end
    end
  end
end
