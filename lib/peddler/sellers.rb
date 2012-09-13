require 'peddler/service'

module Peddler
  # The Amazon MWS Sellers API lets sellers retrieve information about their
  # seller account, such as the marketplaces they participate in.
  class Sellers < Service
    def endpoint
      "https://#{@host}/Sellers/2011-07-01"
    end
  end
end

