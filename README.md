# Evostream

[![Build Status](https://travis-ci.org/globocom/evostream.png?branch=master)](https://travis-ci.org/globocom/evostream)

Ruby wrapper for the Evostream API

## Installation

Add this line to your application's Gemfile:

    gem 'evostream'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evostream

## Usage

```ruby
client = Evostream::Client.new host: 'evostream.example.com', port: 80, path_prefix: '/evo'
client.liststreams
# With parameters
client.pullstream uri: "rtmp://localhost/live/my_stream", localstreamname: "master", keepalive: 1
```

You may use the block style configuration. The following code could be placed
into a +config/initializers/evostream.rb+ when used in a Rails project.

```ruby
# config/initializers/evostream.rb (for instance)

Evostream.configure do |config|
  config.host = 'evostream.example.com'
  config.port = 80
  config.path_prefix = '/evo'

  # Set the username and password when using http basic auth
  # config.username = 'evostream'
  # config.password = 'passw0rd'

  # Set the protocol and port for using HTTPS
  # config.protocol = 'https'
  # config.port = 443
end

# elsewhere

client = Evostream::Client.new
client.liststreams
```

## Running tests

### Local

    $ bundle exec rake spec

### Docker

    $ docker-compose run --rm test

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
