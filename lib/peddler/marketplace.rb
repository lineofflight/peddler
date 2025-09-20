# frozen_string_literal: true

require "peddler/endpoint"

module Peddler
  # @see https://developer-docs.amazon.com/sp-api/docs/marketplace-ids
  MARKETPLACE_IDS = {
    "CA" => { id: "A2EUQ1WTGCTBG2", country_name: "Canada", selling_region: "North America" },
    "US" => { id: "ATVPDKIKX0DER", country_name: "United States", selling_region: "North America" },
    "MX" => { id: "A1AM78C64UM0Y8", country_name: "Mexico", selling_region: "North America" },
    "BR" => { id: "A2Q3Y263D00KWC", country_name: "Brazil", selling_region: "North America" },
    "IE" => { id: "A28R8C7NBKEWEA", country_name: "Ireland", selling_region: "Europe" },
    "ES" => { id: "A1RKKUPIHCS9HS", country_name: "Spain", selling_region: "Europe" },
    "UK" => { id: "A1F83G8C2ARO7P", country_name: "United Kingdom", selling_region: "Europe" },
    "FR" => { id: "A13V1IB3VIYZZH", country_name: "France", selling_region: "Europe" },
    "BE" => { id: "AMEN7PMS3EDWL", country_name: "Belgium", selling_region: "Europe" },
    "NL" => { id: "A1805IZSGTT6HS", country_name: "Netherlands", selling_region: "Europe" },
    "DE" => { id: "A1PA6795UKMFR9", country_name: "Germany", selling_region: "Europe" },
    "IT" => { id: "APJ6JRA9NG5V4", country_name: "Italy", selling_region: "Europe" },
    "SE" => { id: "A2NODRKZP88ZB9", country_name: "Sweden", selling_region: "Europe" },
    "ZA" => { id: "AE08WJ6YKNBMC", country_name: "South Africa", selling_region: "Europe" },
    "PL" => { id: "A1C3SOZRARQ6R3", country_name: "Poland", selling_region: "Europe" },
    "EG" => { id: "ARBP9OOSHTCHU", country_name: "Egypt", selling_region: "Europe" },
    "TR" => { id: "A33AVAJ2PDY3EV", country_name: "Turkey", selling_region: "Europe" },
    "SA" => { id: "A17E79C6D8DWNP", country_name: "Saudi Arabia", selling_region: "Europe" },
    "AE" => { id: "A2VIGQ35RCS4UG", country_name: "United Arab Emirates", selling_region: "Europe" },
    "IN" => { id: "A21TJRUUN4KGV", country_name: "India", selling_region: "Europe" },
    "SG" => { id: "A19VAU5U5O7RUS", country_name: "Singapore", selling_region: "Far East" },
    "AU" => { id: "A39IBJ37TRP1C6", country_name: "Australia", selling_region: "Far East" },
    "JP" => { id: "A1VC38T7YXB528", country_name: "Japan", selling_region: "Far East" },
  }

  # @!parse
  #   # Wraps an Amazon marketplace
  #   #
  #   # @api public
  #   #
  #   # @!attribute [r] id
  #   # @!attribute [r] country_code
  #   # @!attribute [r] country_name
  #   # @!attribute [r] selling_region
  #   class Peddler::Marketplace < Data; end
  Marketplace = Data.define(:id, :country_code, :country_name, :selling_region) do
    class << self
      # Finds the marketplace for the given country code
      #
      # @param [String] country_code
      def find(country_code)
        values = MARKETPLACE_IDS.fetch(country_code == "GB" ? "UK" : country_code) do
          raise ArgumentError, "#{country_code} not found"
        end

        new(**values, country_code: country_code)
      end

      # Returns the marketplace ID for the given country code
      #
      # @param [String] country_code
      # @return [String]
      def id(country_code)
        find(country_code).id
      end

      # Returns the marketplace IDs for the given country codes
      #
      # @param [Array<String>] country_codes
      # @return [Array<String>]
      def ids(*country_codes)
        country_codes.map { |country_code| id(country_code) }
      end

      # Returns all marketplaces
      #
      # @return [Array<Peddler::Marketplace>]
      def all
        MARKETPLACE_IDS.map do |country_code, values|
          new(**values, country_code: country_code)
        end
      end

      # Dynamically generate shorthand methods for each country code
      # e.g., Marketplace.us returns the US marketplace
      MARKETPLACE_IDS.each_key do |country_code|
        method_name = country_code.downcase
        define_method(method_name) do
          find(country_code) # steep:ignore
        end
      end

      # Special alias for GB (Great Britain) -> UK
      define_method(:gb) do
        find("GB") # steep:ignore
      end
    end

    # @return [Peddler::Endpoint]
    # steep:ignore:start
    def endpoint
      Endpoint.find_by_selling_region(selling_region)
    end
    # steep:ignore:end

    # @note So HTTP can encode
    # @return [String]
    # steep:ignore:start
    def to_str
      id
    end
    # steep:ignore:end
  end
end
