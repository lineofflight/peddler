# frozen_string_literal: true

module Configurable
  def aws_region
    config[:aws_region]
  end

  def client_id
    config[:client_id]
  end

  def client_secret
    config[:client_secret]
  end

  def refresh_token
    config[:refresh_token]
  end

  def config
    ["config.json", "config.example.json"].each do |path|
      file = File.join(__dir__, "..", path)
      if File.exist?(file)
        return JSON.load_file(file, symbolize_names: true)
      end
    end
  end
end
