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

    def test_handles_plural_acronyms
      assert_equal("APIs", Acronyms.apply("Apis"))
      assert_equal("ASINs", Acronyms.apply("Asins"))
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
  end
end
