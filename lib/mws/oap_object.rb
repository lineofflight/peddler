require 'nokogiri'

module MWS
  class OAPObject
    NAME_SPLITTER = /^(.+)\s(.+)$/

    attr_reader :api, :id, :response_object, :response_hash

    def initialize(id, api = MWS.off_amazon_payments)
      @id = id
      @api = api
      @response_object = nil
    end

    def fetch!
      raise '#fetch! not implemented on child class'
    end

    def at_path(path)
      find_value(path)
    end

    def at_path!(path)
      find_value(path, true)
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

    def response_hash
      @response_hash ||= MultiXml.parse(response_object.body)
    end

    private

    def find_value(path, raise_on_nil = false)
      node = response_hash.dup

      path.split(' ').each do |part|
        node = node.fetch(part) or break
      end

      if node.nil? && raise_on_nil
        raise Peddler::MissingDataError.new(response_hash, path),
          "Missing response data at '#{path}'"
      end

      node
    end
  end
end
