# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"
require "fileutils"
require "peddler/native/loader"

class LoaderTest < Minitest::Test
  def with_layout(*files)
    Dir.mktmpdir("peddler-loader") do |dir|
      files.each do |file|
        FileUtils.mkdir_p(File.dirname(File.join(dir, file)))
        FileUtils.touch(File.join(dir, file))
      end
      yield dir
    end
  end

  def load_from(dir, abi:, dlext: "so", &requirer)
    required = []
    requirer ||= ->(path) { required << path }
    Peddler::Native::Loader.require_extension(dir: dir, abi: abi, dlext: dlext, requirer: requirer)
    required
  end

  def test_selects_the_extension_for_the_running_abi
    with_layout("3.3/peddler_native.so", "3.4/peddler_native.so", "4.0/peddler_native.so") do |dir|
      assert_equal([File.join(dir, "3.4", "peddler_native.so")], load_from(dir, abi: "3.4"))
      assert_equal([File.join(dir, "4.0", "peddler_native.so")], load_from(dir, abi: "4.0"))
    end
  end

  def test_uses_the_platform_extension_suffix
    with_layout("3.3/peddler_native.bundle") do |dir|
      assert_equal([File.join(dir, "3.3", "peddler_native.bundle")], load_from(dir, abi: "3.3", dlext: "bundle"))
    end
  end

  def test_unpackaged_abi_fails_clearly_without_loading_another_build
    with_layout("3.3/peddler_native.so", "3.4/peddler_native.so", "4.0/peddler_native.so", "peddler_native.so") do |dir|
      required = []
      error = assert_raises(LoadError) { load_from(dir, abi: "4.1") { |path| required << path } }

      assert_empty(required)
      assert_match(/Ruby 3\.3, 3\.4, 4\.0.*this is Ruby 4\.1.*source gem/m, error.message)
    end
  end

  def test_builds_with_another_suffix_are_reported_not_ignored
    with_layout("3.4/peddler_native.bundle") do |dir|
      error = assert_raises(LoadError) { load_from(dir, abi: "3.4", dlext: "so") }

      assert_match(/Ruby 3\.4.*\.so/m, error.message)
    end
  end

  def test_single_build_at_the_top_level_loads
    with_layout("peddler_native.so") do |dir|
      assert_equal([File.join(dir, "peddler_native.so")], load_from(dir, abi: "3.4"))
    end
  end

  def test_load_path_build_is_the_last_resort
    with_layout do |dir|
      assert_equal(["peddler_native"], load_from(dir, abi: "3.4"))
    end
  end

  def test_missing_build_raises_a_clear_error
    with_layout do |dir|
      error = assert_raises(LoadError) do
        load_from(dir, abi: "3.4") { |name| raise LoadError.new("cannot load such file -- #{name}").tap { |e| e.instance_variable_set(:@path, name) } }
      end

      assert_match(/No peddler native extension found for Ruby 3\.4/, error.message)
    end
  end
end
