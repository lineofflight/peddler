# frozen_string_literal: true

require "json"

module Peddler
  # Amazon's marketplaces, by country code
  #
  # https://developer-docs.amazon.com/sp-api/docs/marketplace-ids
  MARKETPLACE_IDS = Ractor.make_shareable({
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
  }) #: Hash[String, { id: String, country_name: String, selling_region: String }]

  # @rbs skip
  Marketplace = Data.define(:id, :country_code, :country_name, :selling_region) # :nodoc:

  # An Amazon marketplace: its `id`, its `country_code`, its `country_name` and its `selling_region`
  class Marketplace
    ##
    # :attr_reader: id
    # Amazon's identifier of the marketplace, such as "ATVPDKIKX0DER"

    ##
    # :attr_reader: country_code
    # The code of its country, such as "US"

    ##
    # :attr_reader: country_name
    # The name of its country, such as "United States"

    ##
    # :attr_reader: selling_region
    # The selling region it is in: "North America", "Europe" or "Far East"

    # Finds the marketplace for the given country code
    #
    #: (String country_code) -> Marketplace
    def self.find(country_code)
      values = MARKETPLACE_IDS[country_code == "GB" ? "UK" : country_code] ||
        raise(ArgumentError, "#{country_code} not found")

      new(**values, country_code: country_code)
    end

    # Returns the marketplace ID for the given country code
    #
    #: (String country_code) -> String
    def self.id(country_code)
      find(country_code).id
    end

    # Returns the marketplace IDs for the given country codes
    #
    #: (*String country_codes) -> Array[String]
    def self.ids(*country_codes)
      country_codes.map { |country_code| id(country_code) }
    end

    # Returns all marketplaces
    #
    #: () -> Array[Marketplace]
    def self.all
      MARKETPLACE_IDS.map do |country_code, values|
        new(**values, country_code: country_code)
      end
    end

    # Dynamically generate shorthand methods for each country code
    # e.g., Marketplace.us returns the US marketplace
    # GB (Great Britain) is a special alias for UK
    #
    # Their blocks are shareable, so that any Ractor can call the methods.
    [*MARKETPLACE_IDS.keys, "GB"].each do |country_code|
      finder = Ractor.make_shareable(proc do
        # @type self: singleton(Marketplace)
        find(country_code)
      end)
      define_singleton_method(country_code.downcase, &finder) # steep:ignore BlockTypeMismatch
    end

    #: () -> Endpoint
    def endpoint
      Endpoint.find_by_selling_region(selling_region)
    end

    # Its ID, so a marketplace is its ID wherever a String is taken
    #: () -> String
    def to_str
      id
    end

    # Its ID as JSON, so a marketplace anywhere inside a request body is sent as its ID
    #: (*untyped) -> String
    def to_json(*)
      id.to_json(*)
    end
  end
end
