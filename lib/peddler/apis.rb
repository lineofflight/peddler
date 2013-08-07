require 'peddler/service'

module Peddler
  class Feeds < Service
  end

  class FulfillmentInboundShipment < Service
    path 'FulfillmentInboundShipment/2010-10-01'
  end

  class FulfillmentInventory < Service
    path 'FulfillmentInventory/2010-10-01'
  end

  class FulfillmentOutboundShipment < Service
    path 'FulfillmentOutboundShipment/2010-10-01'
  end

  class OffAmazonPayments < Service
    path 'OffAmazonPayments/2013-01-01/'
  end

  class Orders < Service
    path 'Orders/2011-01-01'
  end

  class Products < Service
    path 'Products/2011-10-01'
  end

  class Recommendations < Service
    path 'Recommendations/2013-04-01'
  end

  class Reports < Service
  end

  class Sellers < Service
    path 'Sellers/2011-07-01'
  end

  class Subscriptions < Service
    path 'Subscriptions/2013-07-01'
  end
end
