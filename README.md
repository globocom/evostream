# Evostream

Ruby wrapper for the Evostream API

## Installation

Add this line to your application's Gemfile:

    gem 'evostream'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install evostream

## Usage

You may use the block style configuration. The following code could be placed
into a +config/initializers/evostream.rb+ when used in a Rails project.

```ruby
# config/initializers/evostream.rb (for instance)

Evostream.configure do |config|
  config.host = 'evostream.example.com'
  config.port = 80
  config.path_prefix = '/evo'
end

# elsewhere

client = Evostream::Client.new
client.liststreams

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
