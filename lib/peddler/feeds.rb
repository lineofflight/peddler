require 'peddler/service'

module Peddler
  # The Amazon MWS Feeds API lets you upload inventory and order data to
  # Amazon.
  class Feeds < Service
    def endpoint
      "https://#{@host}/"
    end
  end
end
