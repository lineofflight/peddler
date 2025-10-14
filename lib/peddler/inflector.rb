# frozen_string_literal: true

require "zeitwerk"

require "peddler/acronyms"

module Peddler
  class Inflector < Zeitwerk::GemInflector
    def camelize(...)
      Acronyms.apply(super)
    end
  end
end
