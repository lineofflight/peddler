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

    def at_path?(path, value, raise_on_nil = false)
      value_at_path?(response_hash, path, value, raise_on_nil)
    end

    def at_path(path, raise_on_nil = false)
      value_at(response_hash, path, raise_on_nil)
    end

    # First/last name splitting if your data model splits names in two. See NAME_SPLITTER for
    # heuristic.
    #
    def split_name!(path)
      value = at_path(path)

      if matchdata = value.match(NAME_SPLITTER)
        [matchdata[1], matchdata[2]]
      else
        raise Peddler::MalformedDataError.new(path, value),
          "malformed value '#{value}' of node at '#{path}'"
      end
    end

    def response_hash
      @response_hash ||= MultiXml.parse(response_object.body)
    end

    private

    def value_at_path?(xml_structure, path, value, raise_on_nil)
      node = xml_structure.dup
      decend_path = path.split(' ')

      path.split(' ').each do |part|
        decend_path.shift

        if node[part].kind_of?(Hash)
          node = node[part]

        elsif node[part].respond_to?(:each)
          return true if node[part].detect do |n|
            value_at_path?(n, decend_path.join(' '), value, raise_on_nil)
          end

        else
          if node[part].nil? && raise_on_nil
            raise Peddler::MissingDataError.new(response_hash, path),
              "Missing response data at '#{path}'"
          end

          return node[part] == value
        end
      end

      node
    end

    def value_at(xml_structure, path, raise_on_nil = false)
      node = xml_structure.dup

      path.split(' ').each do |part|
        if node[part].nil?
          if raise_on_nil
            raise Peddler::MissingDataError.new(response_hash, path),
              "Missing response data at '#{path}'"
          end

          return nil
        end

        node = node[part]
      end

      node
    end
  end
end
