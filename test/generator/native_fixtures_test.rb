# frozen_string_literal: true

require "helper"
require "base64"
require "json"
require "open3"
require "tmpdir"
require "yaml"

class NativeFixturesTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  SCRIPT = File.join(ROOT, "tools/export_native_fixtures.rb")
  SOURCES = {
    "catalog_get.json" => "test/vcr_cassettes/Peddler/APIs/CatalogItems20220401Test/test_get_catalog_item.yml",
    "listings_patch.json" => "test/vcr_cassettes/Peddler/APIs/ListingsItems20210801Test/test_patch_listings_item.yml",
    "not_found.json" => "test/vcr_cassettes/Peddler/Errors/NotFoundTest/test_not_found.yml",
  }.freeze
  RESPONSE_HEADERS = ["content-type", "x-amzn-requestid", "x-amzn-ratelimit-limit"].freeze

  def setup
    super
    @directory = Dir.mktmpdir
    output, status = export

    raise output unless status.success?
  end

  def teardown
    FileUtils.remove_entry(@directory)
    super
  end

  def test_exports_only_selected_sources
    assert_equal(SOURCES.keys.sort, Dir.children(@directory).sort)
    SOURCES.each { |name, source| assert_equal(source, fixture(name).fetch("source")) }
  end

  def test_preserves_response_status_and_body_bytes
    SOURCES.each do |name, source|
      interaction = YAML.safe_load_file(File.join(ROOT, source)).fetch("http_interactions").find do |entry|
        !entry.fetch("request").fetch("uri").include?("/auth/o2/token")
      end
      response = interaction.fetch("response")
      body = response.fetch("body")
      expected = body.key?("base64_string") ? Base64.decode64(body.fetch("base64_string")) : body.fetch("string").b

      assert_equal(expected, Base64.strict_decode64(fixture(name).fetch("response").fetch("body_base64")))
      assert_equal(response.fetch("status").fetch("code"), fixture(name).fetch("response").fetch("status"))
    end
  end

  def test_whitelists_response_headers
    SOURCES.each_key do |name|
      headers = fixture(name).fetch("response").fetch("headers")

      assert(headers.all? { |key, _value| RESPONSE_HEADERS.include?(key) })
      assert_equal("application/json", headers.assoc("content-type").last)
      assert(headers.assoc("x-amzn-requestid"))
    end
  end

  def test_excludes_auth_and_host_metadata
    SOURCES.each_key do |name|
      refute_match(/access_token|refresh_token|FILTERED|sellingpartnerapi|User-Agent|auth\/o2/i,
        File.read(File.join(@directory, name)))
    end
  end

  def test_catalog_request_retains_ordered_csv_query
    request = fixture("catalog_get.json").fetch("request")

    assert_equal("GET", request.fetch("method"))
    assert_equal("/catalog/2022-04-01/items/188864544X", request.fetch("path"))
    assert_equal([
      ["includedData", "classifications,dimensions,identifiers,images,productTypes,relationships,salesRanks,summaries"],
      ["marketplaceIds", "A1F83G8C2ARO7P"],
    ], request.fetch("query"))
  end

  def test_distinguishes_get_without_body_from_patch_with_json_body
    get = fixture("catalog_get.json").fetch("request")
    patch = fixture("listings_patch.json").fetch("request")

    assert_nil(get.fetch("body_base64"))
    assert_equal("PATCH", patch.fetch("method"))
    assert_equal("PRODUCT", JSON.parse(Base64.strict_decode64(patch.fetch("body_base64"))).fetch("productType"))
  end

  def test_export_is_deterministic
    original = exported_bytes
    output, status = export

    assert_predicate(status, :success?, output)
    assert_equal(original, exported_bytes)
  end

  def test_check_accepts_matching_fixtures
    output, status = export("--check")

    assert_predicate(status, :success?, output)
  end

  def test_check_reports_missing_fixture_without_creating_it
    File.unlink(File.join(@directory, "catalog_get.json"))
    output, status = export("--check")

    refute_predicate(status, :success?, output)
    assert_match(/catalog_get.json/, output)
    refute_path_exists(File.join(@directory, "catalog_get.json"))
  end

  def test_check_reports_changed_fixture_without_rewriting_it
    File.write(File.join(@directory, "catalog_get.json"), "drift")
    output, status = export("--check")

    refute_predicate(status, :success?, output)
    assert_match(/catalog_get.json/, output)
    assert_equal("drift", File.read(File.join(@directory, "catalog_get.json")))
  end

  private

  def fixture(name)
    JSON.parse(File.read(File.join(@directory, name)))
  end

  def exported_bytes
    Dir.children(@directory).to_h { |name| [name, File.binread(File.join(@directory, name))] }
  end

  def export(*arguments)
    Open3.capture2e(RbConfig.ruby, SCRIPT, "--output", @directory, *arguments)
  end
end
