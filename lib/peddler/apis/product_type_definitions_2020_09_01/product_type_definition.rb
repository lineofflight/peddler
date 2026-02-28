# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductTypeDefinitions20200901
      # A product type definition represents the attributes and data requirements for a product type in the Amazon
      # catalog. Product type definitions are used interchangeably between the Selling Partner API for Listings Items,
      # Selling Partner API for Catalog Items, and JSON-based listings feeds in the Selling Partner API for Feeds.
      ProductTypeDefinition = Structure.new do
        # @return [String] Human-readable and localized description of the Amazon product type.
        attribute(:display_name, String, null: false, from: "displayName")

        # @return [String] Locale of the display elements contained in the product type definition.
        attribute(:locale, String, null: false)

        # @return [Array<String>] Amazon marketplace identifiers for which the product type definition is applicable.
        attribute(:marketplace_ids, [String], null: false, from: "marketplaceIds")

        # @return [String] The name of the Amazon product type that this product type definition applies to.
        attribute(:product_type, String, null: false, from: "productType")

        # @return [ProductTypeVersion] The version details for the Amazon product type.
        attribute(:product_type_version, ProductTypeVersion, null: false, from: "productTypeVersion")

        # @return [Hash] Mapping of property group names to property groups. Property groups represent logical groupings
        #   of schema properties that can be used for display or informational purposes.
        attribute(:property_groups, Hash, null: false, from: "propertyGroups")

        # @return [String] Name of the requirements set represented in this product type definition.
        attribute(:requirements, String, null: false)

        # @return [String] Identifies if the required attributes for a requirements set are enforced by the product type
        #   definition schema. Non-enforced requirements enable structural validation of individual attributes without
        #   all of the required attributes being present (such as for partial updates).
        attribute(:requirements_enforced, String, null: false, from: "requirementsEnforced")

        # @return [SchemaLink] Link to schema describing the attributes and requirements for the product type.
        attribute(:schema, SchemaLink, null: false)

        # @return [SchemaLink] Link to meta-schema describing the vocabulary used by the product type schema.
        attribute?(:meta_schema, SchemaLink, from: "metaSchema")
      end
    end
  end
end
