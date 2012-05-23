$:.unshift File.expand_path '../../lib', __FILE__

require 'yaml'

require 'pry'
require 'peddler'

config = YAML::load File.open File.expand_path '../config.yml', __FILE__

@client = MWS::Client.new config['locale']
@client.configure do |c|
  c.key       = config['key']
  c.secret    = config['secret']
  c.seller_id = config['seller_id']
end
