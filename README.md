[![Code Climate](https://codeclimate.com/github/mgi166/dangerous_open_uri/badges/gpa.svg)](https://codeclimate.com/github/mgi166/dangerous_open_uri)

# DangerousOpenUri

Force open dangerous uri.

## Detail

Conclusion, Be using this gem is STRONGLY **deprecated**. Because RFC3986 says userinfo in URI is dangerous.  
So that open-uri will not support it.  

But if you want to open-uri such dangerous uri absolutely, it is preferable to use this gem.  

SEE: https://www.ruby-forum.com/topic/95983

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dangerous_open_uri'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dangerous_open_uri

## Usage

```ruby
require 'dangerous_open_uri'

open('http://user:pass@example.co.jp/secret/page').read
#=> Enable to read `http://user:pass@example.co.jp/secret/page` sources
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dangerous_open_uri/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
