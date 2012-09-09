$:.unshift File.expand_path('../../lib', __FILE__)

require 'pry'
require 'yaml'
require 'peddler'

req = Peddler::Products.new 'US'
req.configure YAML.load_file File.expand_path '../amazon.yml', __FILE__

res = req.get query: { 'Action' => 'GetServiceStatus' }

binding.pry
