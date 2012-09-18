require 'peddler/service'

module Peddler
  # The Products API helps you get information to match your products to
  # existing product listings on Amazon Marketplace websites and to make
  # sourcing and pricing decisions for listing those products on Amazon
  # Marketplace websites.
  class Products < Service
    path 'Products/2011-10-01'
  end
end
