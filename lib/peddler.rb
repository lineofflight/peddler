# Peddler is a Ruby wrapper to the Amazon Inventory management API.
module Peddler
end

require 'active_support/core_ext/hash'
require 'net/https'
require 'ostruct'
require 'peddler/client'
require 'peddler/handlers'
require 'peddler/feeds'
require 'peddler/inventory'
require 'peddler/legacy_reports'
require 'peddler/refunds'
require 'peddler/reports'
require 'peddler/transport'
require 'tempfile'
require 'time'
