# frozen_string_literal: true

require "helper"

# The lookup tests assert several properties of each entry.
# rubocop:disable Minitest/MultipleAssertions
module Peddler
  # The Ruby generator names the typed models. The Rust generator names the operations. This proves the two agree.
  class ParsersTest < Minitest::Test
    INVENTORY = JSON.parse(File.read(File.expand_path("../../crates/peddler-codegen/operation-inventory.json", __dir__)))
    APIS = INVENTORY.fetch("apis")
    OPERATIONS = APIS.flat_map { |api| api.fetch("operations") }

    def test_every_api_has_a_lookup
      assert_equal(APIS.map { |api| api.fetch("module") }.sort, APIs::PARSERS.keys.sort)
      APIs::PARSERS.each do |name, lookup|
        assert_kind_of(Hash, lookup.call)
        assert(lookup.call.keys.all? { |key| key.start_with?("#{name}.") }, "#{name} holds another API's operations")
      end
    end

    def test_every_operation_with_a_json_model_resolves_to_a_model_class
      modeled = OPERATIONS.select { |operation| operation.fetch("successes").any? { |success| success["model"] } }

      refute_empty(modeled)
      modeled.each do |operation|
        key = operation.fetch("key")
        model = parser(key)&.call

        assert_kind_of(Module, model, "#{key} has no typed model")
        assert_respond_to(model, :parse, "#{key} resolves to #{model}, which can't parse")
        assert(model.name.start_with?("Peddler::APIs::"), "#{key} resolves outside Peddler::APIs")
      end
    end

    def test_no_lookup_entry_names_an_operation_the_inventory_lacks
      known = OPERATIONS.map { |operation| operation.fetch("key") }
      entries = APIs::PARSERS.values.flat_map { |lookup| lookup.call.keys }

      assert_empty(entries - known)
      assert_equal(entries.uniq, entries)
    end

    def test_every_lookup_entry_resolves
      APIs::PARSERS.each_value do |lookup|
        lookup.call.each { |key, model| assert_respond_to(model.call, :parse, key) }
      end
    end

    private

    def parser(key)
      APIs::PARSERS.fetch(key.split(".").first).call[key]
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
