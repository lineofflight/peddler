# frozen_string_literal: true

module Peddler
  # Container module for dynamically generated error classes
  module Errors
    class AccessDenied < Error; end
    class InvalidGrant < Error; end
    class InvalidInput < Error; end
    class InvalidRequest < Error; end
    class NotFound < Error; end
    class QuotaExceeded < Error; end
    class Unauthorized < Error; end
    class UnsupportedGrantType < Error; end
  end
end
