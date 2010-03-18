# Peddler is a Ruby wrapper to the Amazon Inventory management API.
module Peddler
  VERSION = '0.2.3'
end

require 'active_support'
require 'net/https'
require 'ostruct'
require File.dirname(__FILE__) + '/peddler/client'
require File.dirname(__FILE__) + '/peddler/handlers'
require File.dirname(__FILE__) + '/peddler/feeds'
require File.dirname(__FILE__) + '/peddler/inventory'
require File.dirname(__FILE__) + '/peddler/legacy_reports'
require File.dirname(__FILE__) + '/peddler/refunds'
require File.dirname(__FILE__) + '/peddler/reports'
require File.dirname(__FILE__) + '/peddler/transport'
require 'tempfile'
require 'time'