require 'peddler/service'

module Peddler
  # The Orders API helps you build simple applications that retrieve only the
  # order information that you need.
  class Orders < Service
    path 'Orders/2011-01-01'
  end
end
