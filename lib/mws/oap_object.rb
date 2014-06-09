require 'nokogiri'

module MWS
  class OAPObject
    NAME_SPLITTER = /^(.+)\s(.+)$/

    attr_reader :api, :response_object, :id

    def initialize(id, api = MWS.off_amazon_payments)
      @id = id
      @api = api
      @response_object = nil
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
        raise Peddler::MissingDataError.new(xml, selector), "Missing response data '#{selector}'"
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
