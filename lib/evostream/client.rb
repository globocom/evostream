# coding: utf-8
require 'base64'
require 'rest-client'
require 'json'

module Evostream
  class Client
    # Define the same set of accessors as the Evostream module
    attr_accessor *Configuration::VALID_CONFIG_KEYS

    def initialize(options = {})
      # Merge the config values from the module and those passed
      # to the client.
      merged_options = Evostream.options.merge(options)

      # Copy the merged values to this client and ignore those
      # not part of our configuration
      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    def method_missing(method, *args)
      params = !args.empty? ? encode_params(args.first) : {}
      response = RestClient.get(service_url(method), { :params => params })
      json = JSON.parse(response.body)
      if json['status'] == 'SUCCESS'
        json['data']
      else
        super
      end
    end

    private
    def service_url(service)
      "#{base_url}/#{service}"
    end

    def base_url
      "http://#{@host}:#{@port}#{@path_prefix}"
    end

    def encode_params(params)
      base64_params = Base64.encode64(params.collect {|k, v| "#{k}=#{v}" }.join(' ')).chomp
      { :params => base64_params }
    end

  end # Client
end
