# coding: utf-8
require 'base64'
require 'json'
require 'net/http'

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

    private
    def method_missing(method, *args)
      params = !args.empty? ? args.first : {}
      response = api_call(method, params)
      if response.code.to_i == 200
        json = parse(response.body)
        if json['status'] == 'SUCCESS'
          json['data']
        elsif json['status'] == 'FAIL' && json['description'] =~ /command .* not known/
          super
        else
          raise json['description']
        end
      else
        raise response.body
      end
    end

    def api_call(method, params)
      uri = URI.parse(service_url(method, params))
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = @timeout
      http.open_timeout = @timeout
      http.request_get(uri.request_uri)
    end

    def service_url(service, params)
      url = "#{base_url}/#{service}"
      unless params.empty?
        url + "?params=#{encode_params(params)}"
      else
        url
      end
    end

    def base_url
      "http://#{@host}:#{@port}#{@path_prefix}"
    end

    def encode_params(params)
      Base64.urlsafe_encode64(params.map {|k, v| "#{k}=#{v}" }.join(' ')).chomp
    end

    def parse(text)
      JSON.parse(text)
    rescue JSON::ParserError => ex
      raise "Invalid response: #{ex.message}"
    end
  end # Client
end
