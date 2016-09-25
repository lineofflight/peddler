require 'delegate'
require 'time'
require 'peddler/structured_list'

module Peddler
  # @api private
  class Operation < SimpleDelegator
    CAPITAL_LETTERS = /[A-Z]/

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

    def store(key, val, parent: '')
      key = camelize(key) if key.is_a?(Symbol)
      key = "#{parent}.#{key}" unless parent.empty?

      val = val.iso8601 if val.respond_to?(:iso8601)
      val = val.to_h if val.is_a?(Struct)

      if val.is_a?(Hash)
        val.each { |keyval| store(*keyval, parent: key) }
      else
        __getobj__.store(key, val)
      end
    end

    def update(hsh)
      hsh.each { |key, val| store(key, val) }
      self
    end

    alias add update

    private

    def camelize(sym)
      return sym.to_s if sym =~ CAPITAL_LETTERS

      sym
        .to_s
        .split('_')
        .map { |token| token == 'sku' ? 'SKU' : token.capitalize }
        .join
    end
  end
end
