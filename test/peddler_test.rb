# frozen_string_literal: true

require "helper"
require "open3"
require "rbconfig"
require "tmpdir"

# The surface tests check several constants at a time.
# rubocop:disable Minitest/MultipleAssertions
class PeddlerTest < Minitest::Test
  ROOT = File.expand_path("..", __dir__)

  def test_entrypoint
    refute_empty(Peddler::APIs.constants)
    refute(defined?(HTTP), "the root entrypoint must not load http.rb")
  end

  def test_new_is_short_for_client_new
    arguments = { region: "us-east-1", access_token: "token", timeout: 5, retries: 2 }
    client = Object.new
    build = ->(**options) { client if options == arguments }

    Peddler::Client.stub(:new, build) { assert_same(client, Peddler.new(**arguments)) }
  end

  def test_public_classes_live_at_the_root
    [
      :Client, :Response, :Error, :LWA, :Document, :TransportError,
      :TimeoutError, :AuthenticationError, :ForkError, :DocumentError, :DocumentTimeoutError, :PaginationError,
      :WorkflowError, :WorkflowTimeoutError,
    ].each { |name| assert(Peddler.const_defined?(name, false), "Peddler::#{name} is missing") }
    [:Pagination, :Continuation].each { |name| refute(Peddler.const_defined?(name, false), "Peddler::#{name} is internal") }
  end

  def test_transport_level_errors_keep_their_hierarchy_and_are_not_api_errors
    assert_equal(Peddler::TransportError, Peddler::TimeoutError.superclass)
    assert_equal(Peddler::DocumentError, Peddler::DocumentTimeoutError.superclass)
    assert_equal(Peddler::WorkflowError, Peddler::WorkflowTimeoutError.superclass)
    [
      Peddler::TransportError, Peddler::AuthenticationError, Peddler::ForkError, Peddler::DocumentError,
      Peddler::PaginationError, Peddler::WorkflowError,
    ].each do |error|
      assert_equal(StandardError, error.superclass)
      refute_operator(error, :<=, Peddler::Error)
    end
  end

  def test_low_level_native_classes_are_private
    [:Engine, :DocumentHandle, :UploadHandle, :LwaEngine].each do |name|
      refute_includes(Peddler::Native.constants, name)
      assert_instance_of(Class, Peddler::Native.const_get(name))
    end
    assert_raises(NameError) { Peddler::Native::Engine }
  end

  # Lays the gem out as a fat platform gem does, with the extension under lib/peddler/<ruby minor>/, and eager-loads
  # it in a fresh process. Zeitwerk must skip the native files and the extension directory.
  def test_eager_loads_from_a_packaged_layout
    extension = $LOADED_FEATURES.grep(/peddler_native\.#{RbConfig::CONFIG["DLEXT"]}\z/).first

    Dir.mktmpdir do |dir|
      lib = File.join(dir, "lib")
      FileUtils.mkdir_p(lib)
      FileUtils.cp_r([File.join(ROOT, "lib/peddler.rb"), File.join(ROOT, "lib/peddler")], lib)
      Dir.glob(File.join(lib, "peddler/{[0-9]*,peddler_native.*}")).each { |path| FileUtils.rm_rf(path) }
      versioned = File.join(lib, "peddler", RUBY_VERSION[/\A\d+\.\d+/])
      FileUtils.mkdir_p(versioned)
      FileUtils.cp(extension, versioned)
      # Bundler puts the checkout's lib on the load path, so the copy has to go in front of it.
      script = <<~RUBY
        $LOAD_PATH.unshift(File.join(Dir.pwd, "lib"))
        require "peddler"
        Zeitwerk::Loader.eager_load_all
        abort("HTTP loaded") if defined?(HTTP)
        loaded = $LOADED_FEATURES.grep(/peddler_native|peddler\.rb/)
        abort("loaded outside the copy: \#{loaded}") unless loaded.all? { |file| file.start_with?(File.realpath(Dir.pwd)) }
        abort("extension not under the Ruby minor") unless loaded.any? { |file| file.start_with?(File.realpath(ARGV.fetch(0))) }
        puts(Peddler::APIs::OrdersV0::GetOrdersResponse.name, Peddler::Client.name)
      RUBY
      output, status = Open3.capture2e(RbConfig.ruby, "-e", script, versioned, chdir: dir)

      assert_predicate(status, :success?, output)
      assert_equal(["Peddler::APIs::OrdersV0::GetOrdersResponse", "Peddler::Client"], output.lines.map(&:chomp).last(2))
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
