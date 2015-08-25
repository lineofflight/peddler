require 'delegate'
require 'time'
require 'peddler/structured_list'

module Peddler
  # @api private
  class Operation < SimpleDelegator
    def initialize(action)
      super('Action' => action)
    end

    def structure!(*list_keys)
      list_key = list_keys.shift
      found_key = keys.find { |key| key.end_with?(list_key) }
      if found_key
        builder = StructuredList.new(found_key, *list_keys)
        vals = delete(found_key)
        update(builder.build(vals))
      end

      self
    end

    def store(key, val)
      key = camelize(key) if key.is_a?(Symbol)

      if val.respond_to?(:iso8601)
        val = val.iso8601
      elsif val.is_a?(Struct)
        val = val.to_h
      end

      if val.is_a?(Hash)
        val.each do |subkey, subval|
          subkey = camelize(subkey) if subkey.is_a?(Symbol)
          store([key, subkey].join('.'), subval)
        end
      else
        __getobj__.store(key, val)
      end
    end

    def update(hsh)
      hsh.each { |key, val| store(key, val) }
      self
    end

    alias_method :add, :update

    private

    def camelize(sym)
      sym
        .to_s
        .split('_')
        .map { |token| token == "sku" ? "SKU" : token.capitalize }
        .join
    end
  end
end
