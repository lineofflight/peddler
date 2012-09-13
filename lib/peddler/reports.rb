require 'peddler/service'

module Peddler
  class Reports < Service
    # The Amazon MWS Reports API lets you request reports about your inventory
    # and orders.
    def endpoint
      "https://#{@host}/"
    end
  end
end

