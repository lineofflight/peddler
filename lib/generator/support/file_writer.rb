# frozen_string_literal: true

require "fileutils"
require "pathname"
require "stringio"
require "rbs"
require "rbs/sorter"

module Generator
  module FileWriter
    def write_file(file_path, content)
      FileUtils.mkdir_p(File.dirname(file_path))
      File.write(file_path, content)
      file_path
    end

    # Batch format files with RuboCop and sort RBS files
    def format_files(files)
      # Separate Ruby files from RBS files
      rbs_files, ruby_files = files.partition { |f| f.end_with?(".rbs") }

      # Format Ruby files with RuboCop
      ruby_files.each_slice(100) do |batch|
        next if batch.empty?

        system(
          "bundle",
          "exec",
          "rubocop",
          "--format",
          "simple",
          "--autocorrect-all",
          "--fail-level",
          "E",
          *batch,
          out: File::NULL,
          err: File::NULL,
        ) ||
          raise("Couldn't format files")
      end

      # Sort RBS files
      rbs_files.each do |file_path|
        sort_rbs_file(file_path)
      end
    end

    private

    def sort_rbs_file(file_path)
      File.open(File::NULL, "w") do |stdout|
        ::RBS::Sorter.new(Pathname(file_path), stdout:).run
      end
    end
  end
end
