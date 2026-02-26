# frozen_string_literal: true

require_relative "configurable"
require_relative "recordable"

module FeatureHelpers
  include Configurable, Recordable

  def api(grantless: false)
    access_token = request_access_token(grantless:)
    api_class.new(aws_region, access_token)
  end

  def api_class
    Object.const_get("Peddler::APIs::#{api_name}")
  end

  def api_name
    self.class.name.split("::").last.sub(/Test$/, "")
  end

  def request_access_token(grantless:)
    payload = if grantless
      scope = "sellingpartnerapi::notifications"
      Peddler::LWA.request(client_id: client_id, client_secret: client_secret, scope: scope)
    else
      Peddler::LWA.request(client_id: client_id, client_secret: client_secret, refresh_token: refresh_token)
    end

    payload.parse.access_token
  end
end
