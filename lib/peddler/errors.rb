# frozen_string_literal: true

require 'peddler/errors/handler'

module Peddler
  # @api private
  module Errors
    MWS.constants.each do |klass|
      MWS.const_get(klass).const_get(:Client).error_handler = Handler
    end
  end
end
