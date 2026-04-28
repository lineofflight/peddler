# frozen_string_literal: true

# Silence http-cookie 1.1.6 load-order warnings.
# https://github.com/sparklemotion/http-cookie/issues/66
if (spec = Gem.loaded_specs["http-cookie"]) && spec.version.to_s != "1.1.6"
  raise "http-cookie #{spec.version} loaded; revisit #{__FILE__}"
end

Warning.singleton_class.prepend(Module.new do
  def warn(msg, ...)
    return if msg.include?("http-cookie") && msg.include?("circular require")
    return if msg.include?("Expected http/cookie to define HTTP::Cookie")

    super
  end
end)
