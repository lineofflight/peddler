module Peddler
  class PeddlerError < StandardError
    def initialize(msg)
      super("#{msg}")
    end
  end
  
  class Transport
    API_HOSTS       = {:us => "secure.amazon.com",
                       :uk => "secure.amazon.co.uk",
                       :de => "secure.amazon.de",
                       :ca => "secure.amazon.ca",
                       :fr => "secure.amazon.fr",
                       :jp => "vendornet.amazon.co.jp" }
    BASE_HEADERS    = {"User-Agent"    => "Peddler/#{Peddler::VERSION}",
                       "Content-Type"  => "text/xml;charset=utf-8",
                       "Cookie"        => "x-main=YvjPkwfntqDKun0QEmVRPcTTZDMe?Tn?; ubid-main=002-8989859-9917520; ubid-tacbus=019-5423258-4241018;x-tacbus=vtm4d53DvX@Sc9LxTnAnxsFL3DorwxJa; ubid-tcmacb=087-8055947-0795529; ubid-ty2kacbus=161-5477122-2773524; session-id=087-178254-5924832;session-id-time=950660664"}
    
    BASE_PARAMS = {
      "Service" => "MerchantQueryService"
    }
    
    attr_writer   :username, :password
    attr_accessor :path, :query_params, :headers, :body
    
    #Returns request instance
    def request
      req = request_method.new("#{self.path.gsub(/\/$/, "")}/#{self.query_string}")
      self.headers.each do |header, value|
        if header.kind_of? Symbol
          req[header.to_s.gsub(/_/, "")] = value
        else
          req[header] = value
        end
      end
      req.basic_auth(@username, @password) if @username && @password
      req.body = self.body unless self.body.empty?
      req
    end
    
    def execute_request
      begin
        self.conn.start do |http|
          res = http.request(self.request)
          case res
          when Net::HTTPSuccess
            res.body
          else
            raise PeddlerError.new(res.body)
          end
        end
      end
    end
    
    def clear_request
      self.headers = BASE_HEADERS.dup
      self.body = ""
    end
    
    def legacize_request
      self.clear_request
      self.path = "/exec/panama/seller-admin/"
      self.query_params = {}
    end
    
    def modernize_request
      self.clear_request
      self.path = "/query/"
      self.query_params = BASE_PARAMS.dup
    end
    
    def region=(region)
      @conn = nil
      region = region.to_sym
      if API_HOSTS.has_key?(region)
        @region = region
      else
        raise PeddlerError.new("Region not recognized")
      end
    end
    
    def url
      URI.parse("https://#{self.host}#{self.path.gsub(/\/$/, "")}/#{self.query_string}")
    end
    
    def dump_headers(msg)
      msg.each_header do |key, value|
        p "#{key}=#{value}"
      end
    end
    
  protected
    #Returns Net::HTTP instance
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
      if !self.body.empty? || !self.query_params.empty?
        Net::HTTP::Post
      else
        Net::HTTP::Get
      end
    end
    
    def host
      API_HOSTS[@region]
    end
    
    def query_string
      unless query_params.empty?
        query_params.inject("?") do |out, pair|
          key, value = pair
          key = key.to_s.gsub(/_([a-z])/) { $1.upcase } if key.kind_of? Symbol
          value = value.httpdate if value.respond_to? :httpdate
          out += "&" if out.size > 1
          "#{out}#{url_encode(key)}=#{url_encode(value)}"
        end
      end
    end
    
    def url_encode(value)
      require 'cgi' unless defined?(CGI) && defined?(CGI::escape)
      CGI.escape(value.to_s)
    end
  end
end