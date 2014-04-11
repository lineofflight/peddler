require 'peddler/client'

module MWS
  # The Fulfillment Inventory API can help you stay up-to-date on the
  # availability of your inventory in the Amazon Fulfillment Network. The
  # Fulfillment Inventory API reports real-time availability information for
  # your Amazon Fulfillment Network inventory regardless of whether you are
  # selling your inventory on Amazon's retail web site or through other retail
  # channels.
  #
  # @todo Not implemented
  class FulfillmentInventory < ::Peddler::Client
    path '/FulfillmentInventory/2010-10-01'
  end
end
