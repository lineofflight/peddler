# Peddler

[![travis][1]][2]

![Peddler][3]

Peddler wraps the [Amazon Marketplace Web Service (MWS) APIs][4].

```ruby
request = Peddler::Products.new 'US'

request.configure key:      'key',
                  secret:   'secret',
                  seller:   'seller'

request.get query: { 'Action => 'GetServiceStatus' }
```

[1]: https://secure.travis-ci.org/papercavalier/peddler.png
[2]: http://travis-ci.org/papercavalier/peddler
[3]: http://f.cl.ly/items/0W3V0A1Z110Q0x461b3H/mussels.jpeg
[4]: https://developer.amazonservices.com/gp/mws/docs.html
