require 'mws/off_amazon_payments'
require 'nokogiri'

module Peddler
  # This class models an Amazon Order Reference Object, which is a record created on their end to track information
  # about an orders placed using Off-Amazon Payments.
  class OrderReferenceObject
    PARTIAL_ADDRESS_CONTRAINT = "AmountNotSet"
    NAME_SPLITTER = /^(.+)\s(.+)$/

    attr_reader :api
    attr_accessor :oro_id, :response_object

    def initialize(oro_id, api = MWS.off_amazon_payments)
      @oro_id = oro_id
      @api = api
      @response_object = nil
    end

    def fetch!
      self.response_object = api.get_order_reference_details(oro_id)
    end

    def partial_destination_address?
      css("Constraints > Constraint > ConstraintID").include?(PARTIAL_ADDRESS_CONTRAINT)
    end

    def css(selector)
      simple_xml_select(response_object.body, selector, false)
    end

    def css!(selector)
      simple_xml_select(response_object.body, selector, true)
    end

    # First/last name splitting if your data model splits names in two. See NAME_SPLITTER for
    # heuristic.
    #
    def split_name!(selector)
      value = css!(selector)

      if matchdata = value.match(NAME_SPLITTER)
        [matchdata[1], matchdata[2]]
      else
        raise Amazon::MalformedDataError.new(selector, value),
          "malformed value '#{value}' of node '#{selector}'"
      end
    end

    private

    def with_pretty_error_handling
      yield

    rescue => e
      if e.class.parent == Excon::Errors
        xml = Nokogiri::XML(e.response.body)
        raise ApiError.new(e.request, e.response),
          "#{xml.at_css('Error > Code')}: #{xml.at_css('Error > Message')}"
      else
        raise
      end
    end

    def price_object(amount)
      {"Amount" => amount, "CurrencyCode" => "USD"}
    end

    def simple_xml_select(xml, selector, raise_on_nil = false)
      node = get_node(xml, selector)

      if node.nil? && raise_on_nil
        raise MissingDataError.new(xml, selector), "Missing response data '#{selector}'"
      elsif node.nil?
        ""
      else
        node.text
      end
    end

    def get_node(xml, selector)
      Nokogiri::XML(xml).at_css(selector)
    end
  end
end
