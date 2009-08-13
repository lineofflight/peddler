# Peddler is a Ruby wrapper to the Amazon Inventory management API.
module Peddler
  VERSION = "0.1"  
end

class String #:nodoc: all
  def camelize
    self.gsub(/(^|_)(.)/) { $2.upcase }
  end
end

require "net/https"
require "ostruct"
require "tempfile"
require "time"
require "xmlsimple"

require File.dirname(__FILE__) + "/peddler/client"
require File.dirname(__FILE__) + "/peddler/handlers"
require File.dirname(__FILE__) + "/peddler/feeds"
require File.dirname(__FILE__) + "/peddler/inventory"
require File.dirname(__FILE__) + "/peddler/legacy_reports"
require File.dirname(__FILE__) + "/peddler/refunds"
require File.dirname(__FILE__) + "/peddler/reports"
require File.dirname(__FILE__) + "/peddler/transport"
