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

# IPA
module IPA
  # Client
  class Client
    attr_reader :uri, :http, :headers

    def initialize(host: nil, ca_cert: '/etc/ipa/ca.crt')
      raise ArgumentError, 'Missing FreeIPA host' unless host

      @uri = URI.parse("https://#{host}/ipa/session/json")

      @http = HTTPClient.new
      @http.ssl_config.set_trust_ca(ca_cert)
      @headers = { 'referer' => "https://#{uri.host}/ipa/json", 'Content-Type' => 'application/json', 'Accept' => 'application/json' }

      login(host)
    end

    def login(host)
      # Set the timeout to 15 minutes
      @session_timeout = (Time.new.to_i + 900)

      gssapi = GSSAPI::Simple.new(@uri.host, 'HTTP')
      # Initiate the security context
      token = gssapi.init_context

      login_uri = URI.parse("https://#{host}/ipa/session/login_kerberos")
      login_request = { method: 'ping', params: [[], {}] }
      login_headers = { 'referer' => "https://#{uri.host}/ipa/ui/index.html", 'Content-Type' => 'application/json', 'Accept' => 'application/json', 'Authorization' => "Negotiate #{Base64.strict_encode64(token)}" }

      http.post(login_uri, login_request.to_json, login_headers)
    end

    def api_post(method: nil, item: [], params: {})
      raise ArgumentError, 'Missing method in API request' unless method

      login if Time.new.to_i > @session_timeout

      request = {}
      request[:method] = method
      request[:params] = [[item || []], params]
      resp = http.post(uri, request.to_json, headers)
      JSON.parse(resp.body)
    end

    def host_add(hostname: nil, all: false, force: false, random: nil, userpassword: nil, params: {})
      raise ArgumentError, 'Hostname is required' unless hostname

      params[:all] = all
      params[:force] = force
      params[:random] = random unless random.nil?
      params[:userpassword] = userpassword unless userpassword.nil?

      api_post(method: 'host_add', item: hostname, params: params)
    end

    def host_del(hostname: nil, params: {})
      raise ArgumentError, 'Hostname is required' unless hostname

      api_post(method: 'host_del', item: hostname, params: params)
    end

    def host_find(hostname: nil, all: false, params: {})
      params[:all] = all

      api_post(method: 'host_find', item: hostname, params: params)
    end

    def host_show(hostname: nil, all: false, params: {})
      raise ArgumentError, 'Hostname is required' unless hostname

      params[:all] = all

      api_post(method: 'host_show', item: hostname, params: params)
    end

    def host_exists?(hostname)
      resp = host_show(hostname: hostname)
      if resp['error']
        false
      else
        true
      end
    end
  end
end
