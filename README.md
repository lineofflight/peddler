# Peddler

[![travis][status]][travis]

![Peddler][mussels]

Peddler wraps the [Amazon Marketplace Web Service (MWS) APIs][mws].

## Notice

The current master is an early work-in-progress. I'll be wading through and
implementing the APIs as need dictates. Patches are more than welcome.

If you are looking for the wrapper to the deprecated AIM API,
[go here][old-peddler].

## Usage

```ruby
client = MWS::Client.new 'US'
client.configure do |c|
  c.key       = 'key'
  c.secret    = 'secret'
  c.seller_id = 'seller_id'
end

client.get_lowest_offer_listings_for_asin '0143105825'
```

[status]: https://secure.travis-ci.org/hakanensari/peddler.png
[travis]: http://travis-ci.org/hakanensari/peddler
[old-peddler]: https://github.com/hakanensari/peddler/tree/v0.3.1
[mussels]: http://f.cl.ly/items/0W3V0A1Z110Q0x461b3H/mussels.jpeg
[mws]: https://developer.amazonservices.com/gp/mws/docs.html
