module Peddler
  UnknownMarketplaceIdError = Class.new(StandardError)

  class ApiError < StandardError
    attr_accessor :request, :response

    def initialize(request, response)
      @request = request
      @response = response
    end
  end

  class MissingDataError < StandardError
    attr_accessor :xml, :selector

    def initialize(xml, selector)
      @xml = xml
      @selector = selector
    end
  end

  class MalformedDataError < StandardError
    attr_accessor :selector, :value

    def initialize(selector, value)
      @selector = selector
      @value = value
    end
  end
end
