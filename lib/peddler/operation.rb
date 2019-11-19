# frozen_string_literal: true

require 'delegate'
require 'time'
require 'peddler/structured_list'

module Peddler
  # @!visibility private
  class Operation < SimpleDelegator
    CAPITAL_LETTERS = /[A-Z]/.freeze
    ALL_CAPS = %w[sku cod].freeze
    private_constant :CAPITAL_LETTERS, :ALL_CAPS

    def initialize(action)
      super('Action' => action)
    end

    def structure!(*list_keys)
      list_key = list_keys.shift
      keys
        .find_all { |key| key.end_with?(list_key) }
        .each do |found_key|
          builder = StructuredList.new(found_key, *list_keys)
          vals = delete(found_key)
          update(builder.build(vals))
        end

      self
    end

    def store(key, val, parent: nil)
      key = [parent, camelize(key)].compact.join('.')
      val = format_known_types(val)

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

    def camelize(key)
      return key unless key.is_a?(Symbol)
      return key.to_s if key.match?(CAPITAL_LETTERS)

      key
        .to_s
        .split('_')
        .map { |token| capitalize(token) }
        .join
    end

    def capitalize(word)
      if ALL_CAPS.any? { |val| val == word }
        word.upcase
      else
        word.capitalize
      end
    end

    def format_known_types(val)
      val = val.utc.iso8601(2) if val.is_a?(Time)
      val = val.iso8601 if val.is_a?(Date)
      val = val.to_h if val.is_a?(Struct)

      val
    end
  end
end
