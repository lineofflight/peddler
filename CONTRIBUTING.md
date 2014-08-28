# Contributing
**Peddler** is a simple wrapper that maps one-on-one to the MWS APIs and their various operations. It treats required request parameters as ordinary arguments and optional ones as keyword arguments. It parses XML responses with [MultiXml][xml]. Tab-delimited files are handled with [CSV][csv].

[xml]: https://github.com/sferik/multi_xml
[csv]: https://github.com/ruby/ruby/blob/trunk/lib/csv.rb

Further abstraction is not in the scope of this project. As an example implementation built on **Peddler**, see [MWS Orders][mws-orders], which provides a richer interface to the same-named API.

[mws-orders]: https://github.com/hakanensari/mws-orders
