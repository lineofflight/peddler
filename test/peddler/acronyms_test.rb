# frozen_string_literal: true

require "helper"

module Peddler
  class AcronymsTest < Minitest::Test
    def test_applies_single_acronyms
      assert_equal("B2BAnyOfferChanged", Acronyms.apply("B2bAnyOfferChanged"))
      assert_equal("TestAPIV1", Acronyms.apply("TestApiV1"))
    end

    def test_applies_end_acronyms
      assert_equal("ProductSKU", Acronyms.apply("ProductSku"))
      assert_equal("RedirectURL", Acronyms.apply("RedirectUrl"))
    end

    def test_handles_urls_plural
      assert_equal("ClaimProofURLs", Acronyms.apply("ClaimProofUrls"))
      assert_equal("URLs", Acronyms.apply("Urls"))
    end

    def test_handles_apis_plural
      assert_equal("APIs", Acronyms.apply("Apis"))
    end

    def test_prevents_partial_matches
      assert_equal("ErrorCode", Acronyms.apply("ErrorCode"))
      assert_equal("RapidTest", Acronyms.apply("RapidTest"))
    end

    def test_handles_multiple_acronyms
      assert_equal("FBASKU", Acronyms.apply("FbaSku"))
      assert_equal("CODSettings", Acronyms.apply("CodSettings"))
    end

    def test_returns_acronym_values
      refute_empty(Acronyms.values)
    end

    # The generator of the API classes keeps the list a second time, in Rust. Either one changed alone fails here.
    def test_the_rust_generator_keeps_the_same_list
      source = File.read(File.expand_path("../../crates/peddler-codegen/src/facades.rs", __dir__))
      list = source[/^const ACRONYMS: .+? = \[(.+?)^\];/m, 1].to_s.scan(/\("(\w+)", "(\w+)"\)/)

      assert_equal(Acronyms::MAP.to_a, list)
    end
  end
end
