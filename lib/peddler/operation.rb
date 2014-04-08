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
      list_key = list_keys.first

      if has_key?(list_key)
        builder = StructuredList.new(*list_keys)
        vals = delete(list_key)
        update(builder.build(vals))
      end

      self
    end

    def store(key, val)
      key = camelize(key) if key.is_a?(Symbol)
      val = val.iso8601 if val.respond_to?(:iso8601)

      __getobj__.store(key, val)
    end

    def update(hsh)
      hsh.each { |key, val| store(key, val) }
      self
    end

    alias :add :update

    private

    def camelize(sym)
      sym.to_s.split('_').map(&:capitalize).join
    end
  end
end
