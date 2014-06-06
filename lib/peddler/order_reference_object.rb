require 'mws/off_amazon_payments'
require 'nokogiri'

module Peddler
  # This class models an Amazon Order Reference Object, which is a record created on their end to track information
  # about orders placed using Off-Amazon Payments.
  class OrderReferenceObject
    PARTIAL_ADDRESS_CONTRAINT = "AmountNotSet"
    NAME_SPLITTER = /^(.+)\s(.+)$/

    attr_reader :api, :response_object, :oro_id

    def initialize(oro_id, api = MWS.off_amazon_payments)
      @oro_id = oro_id
      @api = api
      @response_object = nil
    end

    def fetch!
      @response_object = api.get_order_reference_details(oro_id)
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
        raise Peddler::MalformedDataError.new(selector, value),
          "malformed value '#{value}' of node '#{selector}'"
      end
    end

    private

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
