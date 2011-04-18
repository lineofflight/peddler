# encoding: utf-8

module Peddler
  class PeddlerError < StandardError
    def initialize(msg)
      super(msg)
    end
  end

  # Our work horse. Runs on top of Net::HTTP.
  class Transport
    API_HOSTS = {
      :us => 'secure.amazon.com',
      :uk => 'secure.amazon.co.uk',
      :de => 'secure.amazon.de',
      :ca => 'secure.amazon.ca',
      :fr => 'secure.amazon.fr',
      :jp => 'vendornet.amazon.co.jp'
    }

    BASE_HEADERS  = {
      'User-Agent'    => "Peddler/#{Peddler::VERSION}",
      'Cookie'        => 'x-main=YvjPkwfntqDKun0QEmVRPcTTZDMe?Tn?; ubid-main=002-8989859-9917520; ubid-tacbus=019-5423258-4241018;x-tacbus=vtm4d53DvX@Sc9LxTnAnxsFL3DorwxJa; ubid-tcmacb=087-8055947-0795529; ubid-ty2kacbus=161-5477122-2773524; session-id=087-178254-5924832;session-id-time=950660664'
    }

    BASE_PARAMS = {
      'Service' => 'MerchantQueryService'
    }

    attr_writer   :username, :password
    attr_accessor :path, :query_params, :headers, :body

    #Returns request instance
    def request
      req = request_method.new("#{path.gsub(/\/$/, "")}/#{query_string}")
      headers.each do |header, value|
        if header.kind_of? Symbol
          req[header.to_s.gsub(/_/, '')] = value
        else
          req[header] = value
        end
      end
      req.basic_auth(@username, @password) if @username && @password
      req.body = body if body
      req
    end

    def execute_request
      begin
        conn.start do |http|
          http.read_timeout = 500
          res = http.request(request)
          case res
          when Net::HTTPSuccess
            body = res.body
            # A hacky way to encode Japanese response bodies into UTF-8 if in Ruby 1.9
            if body.respond_to?(:encoding) && @region == :jp
              body.force_encoding("Shift_JIS").encode("UTF-8")
            else
              body
            end
          else
            raise PeddlerError.new(res.body)
          end
        end
      end
    end

    def clear_request
      self.headers = BASE_HEADERS.dup
      self.headers['Content-Type'] =
        if [:fr, :de].include? @region
          'text/xml;charset=utf-8'
        else
          'text/xml'
      end
      self.body = nil
    end

    def legacize_request
      clear_request
      self.path = '/exec/panama/seller-admin/'
      self.query_params = {}
    end

    def modernize_request
      clear_request
      self.path = '/query/'
      self.query_params = BASE_PARAMS.dup
    end

    def region=(region)
      @conn = nil
      region = region.to_sym
      if API_HOSTS.has_key?(region)
        @region = region
      else
        raise PeddlerError.new('Region not recognized')
      end
    end

    def url
      URI.parse("https://#{host}#{path}#{query_string}")
    end

    def dump_headers(msg)
      msg.each_header do |k, v|
        p "#{k}=#{v}"
      end
    end

    private

    #Returns the Net::HTTP instance.
    def conn
      if @conn
        @conn
      else
        conn = Net::HTTP.new(host, 443)
        conn.use_ssl = true
        conn.verify_mode = OpenSSL::SSL::VERIFY_NONE
        @conn = conn
      end
    end

    def request_method
      if !body.nil? || (query_params && !query_params.empty?)
        Net::HTTP::Post
      else
        Net::HTTP::Get
      end
    end

    def host
      API_HOSTS[@region]
    end

    def query_string
      if query_params && !query_params.empty?
        params = query_params.collect do |k, v|
          k = k.to_s.gsub(/_([a-z])/) { $1.upcase } if k.kind_of? Symbol
          v = v.httpdate if v.respond_to? :httpdate
          "#{k}=#{v}"
        end
        "?#{params.join('&')}"
      end
    end
  end
end
