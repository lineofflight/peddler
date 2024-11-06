# frozen_string_literal: true

module Generator
  module Config
    BASE_PATH = File.expand_path("../..", __dir__)

    class << self
      def template_path(template_name)
        File.join(BASE_PATH, "lib/generator/templates/#{template_name}.rb.erb")
      end
    end
  end
end
