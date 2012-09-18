%w(
  feeds fulfillment_inbound_shipment fulfillment_inventory
  fulfillment_outbound_shipment orders products reports sellers
).each do |service|
  require "peddler/#{service}"
end
