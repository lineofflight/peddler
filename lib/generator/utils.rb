# frozen_string_literal: true

require "generator/config"

module Generator
  module Utils
    def snakecase(string)
      string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .gsub(/(\d{4})(\d{2})(\d{2})/, '_\1_\2_\3') # Format date-like sequences
        .tr("-", "_")
        .downcase
    end

    def pascalcase(string, acronyms: ["FBA"])
      s = string.split(/[_\s-]/).map(&:capitalize).join
      acronyms.each { |a| s.gsub!(/#{a.capitalize}/, a.upcase) }
      s
    end
  end
end
