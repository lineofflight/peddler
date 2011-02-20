# encoding: utf-8

require 'active_support/core_ext/hash'
require 'net/https'
require 'ostruct'
require 'peddler/version'
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

# = Peddler
#
# Peddler is a Ruby wrapper to the {Amazon Inventory management API}[https://images-na.ssl-images-amazon.com/images/G/01/Amazon_AIM/Amazon_AIM.pdf].
module Peddler
end
