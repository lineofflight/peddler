require 'peddler/client'

module MWS
  # The Recommendations API enables you to programmatically retrieve Amazon
  # Selling Coach recommendations by recommendation category. A recommendation
  # is an actionable, timely, and personalized opportunity to increase your
  # sales and performance.
  #
  # @todo Not implemented
  class Recommendations < ::Peddler::Client
    path 'Recommendations/2013-04-01'
  end
end
