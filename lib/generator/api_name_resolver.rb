# frozen_string_literal: true

require "set"

module Generator
  class APINameResolver
    FILENAME_BASED_DIRECTORIES = Set.new([
      "external-fulfillment",
      "finances-api-model",
    ]).freeze

    attr_reader :file

    def initialize(file)
      @file = file
    end

    def name
      if filename_based_directory?
        extract_name_from_filename
      else
        extract_name_from_directory
      end
    end

    class << self
      def validate_no_unmapped_collisions!(api_files)
        api_files_by_dir = api_files.group_by { |file| File.basename(File.dirname(file)) }

        api_files_by_dir.each do |dir_name, files|
          next if files.size == 1

          base_names = files.map { |file| extract_base_name(file) }.uniq

          next if base_names.size <= 1 || FILENAME_BASED_DIRECTORIES.include?(dir_name)

          file_list = files.map { |f| File.basename(f) }.join(", ")
          raise "Error: Found multiple APIs in directory '#{dir_name}' with different base names: #{file_list}. " \
            "Please add this directory to FILENAME_BASED_DIRECTORIES"
        end
      end

      private

      def extract_base_name(file)
        basename = File.basename(file, ".json")
        basename.sub(/[_-]\d{4}[-_]\d{2}[-_]\d{2}$/, "").sub(/V\d+$/, "")
      end
    end

    private

    def directory_name
      File.basename(File.dirname(file))
    end

    def filename_based_directory?
      FILENAME_BASED_DIRECTORIES.include?(directory_name)
    end

    def extract_name_from_filename
      base_name = self.class.extract_base_name(file)
      base_name.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase.tr("-", "_")
    end

    def extract_name_from_directory
      directory_name.sub(/-api-model$/, "").sub(/-model$/, "").tr("-", "_")
    end
  end
end
