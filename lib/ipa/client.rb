#!/usr/bin/env ruby
#
# client.rb
#
# Author: Matteo Cerutti <matteo.cerutti@hotmail.co.uk>
#

require 'httpclient'
require 'base64'
require 'gssapi'
require 'json'

module IPA
  class Client
    attr_reader :uri, :http, :headers

    def initialize(host: nil, ca_cert: '/etc/ipa/ca.crt')
      raise ArgumentError, 'Missing FreeIPA host' unless host

      @uri = URI.parse("https://#{host}/ipa/json")

      gssapi = GSSAPI::Simple.new(uri.host, 'HTTP')
      # Initiate the security context
      token = gssapi.init_context

      @http = HTTPClient.new
      @http.ssl_config.set_trust_ca(ca_cert)
      @headers = {'referer' => "https://#{uri.host}/ipa/ui/index.html", 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => "Negotiate #{Base64.strict_encode64(token)}"}
    end

    def api_post(method: nil, item: [], params: {})
      raise ArgumentError, 'Missing method in API request' unless method
      request = {}
      request[:method] = method
      request[:params] = [[item || []], params]
      resp = self.http.post(self.uri, request.to_json, self.headers)
      JSON.parse(resp.body)
    end

    def host_add(hostname: nil, all: false, force: false, random: nil, userpassword: nil, params: {})
      raise ArgumentError, 'Hostname is required' unless hostname

      params[:all] = all
      params[:force] = force
      params[:random] = random unless random.nil?
      params[:userpassword] = userpassword unless userpassword.nil?

      self.api_post(method: 'host_add', item: hostname, params: params)
    end

    def host_del(hostname: nil, params: {})
      raise ArgumentError, 'Hostname is required' unless hostname

      self.api_post(method: 'host_del', item: hostname, params: params)
    end

    def host_find(hostname: nil, all: false, params: {})
      params[:all] = all

      self.api_post(method: 'host_find', item: hostname, params: params)
    end

    def host_show(hostname: nil, all: false, params: {})
      raise ArgumentError, 'Hostname is required' unless hostname

      params[:all] = all

      self.api_post(method: 'host_show', item: hostname, params: params)
    end

    def host_exists?(hostname)
      resp = self.host_show(hostname: hostname)
      if resp['error']
        false
      else
        true
      end
    end
  end
end
