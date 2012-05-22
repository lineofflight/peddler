# Peddler

[![travis][status]][travis]

![Peddler][mussels]

Peddler wraps the [Amazon Marketplace Web Service (MWS) APIs][mws].

## Usage

```ruby
client = Peddler.new 'US', key:            'key',
                           marketplace_id: '123',
                           secret:         'secret'

client.get_lowest_offer_listings_for_asin asins
```

[status]: https://secure.travis-ci.org/hakanensari/peddler.png
[travis]: http://travis-ci.org/hakanensari/peddler
[mussels]: http://f.cl.ly/items/0W3V0A1Z110Q0x461b3H/mussels.jpeg
[mws]: https://developer.amazonservices.com/gp/mws/docs.html
