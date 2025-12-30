# frozen_string_literal: true

module Peddler
  # Handles acronym transformations for Amazon SP-API terminology
  module Acronyms
    extend self

    # Mapping of camelized forms to their uppercase acronym equivalents
    MAP = {
      "Api" => "API",
      "Apis" => "APIs",
      "Asin" => "ASIN",
      "B2b" => "B2B",
      "Cgst" => "CGST",
      "Cod" => "COD",
      "Ebt" => "EBT",
      "Fba" => "FBA",
      "Igst" => "IGST",
      "Lwa" => "LWA",
      "Safet" => "SAFET",
      "Sgst" => "SGST",
      "Sku" => "SKU",
      "Tds" => "TDS",
      "Url" => "URL",
      "Urls" => "URLs",
    }.freeze

    # Transforms acronyms in camelized words to uppercase equivalents. Uses lookahead to prevent partial matches
    # within words (e.g., "Cod" won't match inside "Code"). Plural forms require explicit mappings (e.g.,
    # "Urls" => "URLs").
    #
    # @param word [String]
    # @return [String]
    def apply(word)
      MAP.reduce(word) { |w, (from, to)| w.gsub(/#{from}(?=[A-Z]|$)/) { to } }
    end

    # @return [Array<String>] Array of uppercase acronyms
    def values
      MAP.values
    end
  end
end
