# coding: utf-8
module Evostream
  module Configuration
    VALID_CONFIG_KEYS = [:host, :port, :path_prefix, :username, :password].freeze
    OPTIONAL_CONFIG_KEYS = VALID_CONFIG_KEYS - [:host]

    DEFAULT_PORT = 80
    DEFAULT_PATH_PREFIX = ''
    DEFAULT_USERNAME = ''
    DEFAULT_PASSWORD = ''

    # Build accessor methods for every config options so we can do this, for example:
    #   Evostream.host = 'evostream.example.com'
    attr_accessor *VALID_CONFIG_KEYS

    # Make sure we have the default values set when we get 'extended'
    def self.extended(base)
      base.reset
    end

    def reset
      self.port        = DEFAULT_PORT
      self.path_prefix = DEFAULT_PATH_PREFIX
      self.username    = DEFAULT_USERNAME
      self.password    = DEFAULT_PASSWORD
    end

    # config/initializers/evostream.rb (for instance)
    #
    # Evostream.configure do |config|
    #   config.host = 'evostream.example.com'
    #   config.port = 80
    #   config.path_prefix = '/evo'
    #   config.username = 'evo'
    #   config.password = 'password'
    # end
    #
    # elsewhere
    #
    # client = Evostream::Client.new
    #
    def configure
      yield self
      true
    end

    def options
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end

  end # Configuration
end
