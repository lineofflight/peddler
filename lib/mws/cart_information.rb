require 'peddler/client'

module MWS
  # With the Cart Information API, you can retrieve shopping carts that your
  # Amazon Webstore customers have created. The Cart Information API enables you
  # to programmatically integrate Amazon Webstore cart information with your CRM
  # systems, marketing applications, and other systems that require cart data.
  #
  # @todo Not implemented
  class CartInformation < ::Peddler::Client
    path '/CartInformation/2014-03-01'
  end
end
