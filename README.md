# Peddler

![Peddler][1]

Peddler provides a light-weight wrapper around the [Amazon Marketplace Web
Service (MWS) APIs][2].

## Usage

```ruby
client = Peddler::Products.new('US', 'aws_key', 'aws_secret', 'seller_id')
params = {
  'Marketplace' => client.marketplace_id('US'),
  'Action'      => 'ListMatchingProducts',
  'Query'       => 'Architecture'
}

res = client.get(query: params)
```

[1]: http://f.cl.ly/items/0W3V0A1Z110Q0x461b3H/mussels.jpeg
[2]: https://developer.amazonservices.com/gp/mws/docs.html
