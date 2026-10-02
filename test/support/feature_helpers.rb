# frozen_string_literal: true

require_relative "replay"

# Replays the cassette recorded for a test through a client pointed at a loopback server
module FeatureHelpers
  def setup
    super
    @replay = Replay.new(cassette)
  end

  # The cassette recorded for the test, by its class and name
  def cassette
    "#{self.class.name}/#{name}".gsub("::", "/")
  end

  def teardown
    @replay&.stop
    super
  end

  # Asserts a 2xx response whose recorded body, when it has one, parses into the operation's typed model
  #
  # Pass typed: false for a sandbox body that omits fields the spec requires. The typed model rejects those, as it
  # did in v5, so only the Hash is checked.
  def assert_success(res, typed: true)
    assert_includes(200..299, res.status)
    return if res.body.empty?
    return assert_kind_of(Hash, res.to_h) unless typed

    operation = res.instance_variable_get(:@operation)
    modeled = Peddler::APIs::PARSERS.fetch(api_name).call.key?(operation)

    assert_equal(modeled, !res.parse.is_a?(Hash), "#{operation} should parse into #{modeled ? "its typed model" : "a Hash"}")
  end

  # Points a recorded absolute URL, such as a signed document URL, at the replay server
  def replayed(url)
    "#{@replay.url}#{URI(url).request_uri}"
  end

  def client
    Peddler::Client.new(base_url: @replay.url, access_token: "FILTERED")
  end

  def api
    client.public_send(api_name)
  end

  def api_name
    class_name = self.class.name.split("::").last.delete_suffix("Test")
    inflector = Peddler::Inflector.new(File.join(Replay::ROOT, "lib/peddler.rb"))

    Peddler::APIs::PARSERS.keys.find { |name| inflector.camelize(name, nil) == class_name } ||
      raise("no API for #{class_name}")
  end
end
