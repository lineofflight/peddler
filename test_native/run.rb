# frozen_string_literal: true

Dir.glob(File.expand_path("*_test.rb", __dir__)).sort.each { |path| require path }
