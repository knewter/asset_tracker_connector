require 'httparty'
require 'ostruct'

class AssetTrackerIntegrator
  include HTTParty
  base_uri 'http://localhost:3000/'
  attr_accessor :last_result

  def initialize(url)
    raise "You must specify an URL when initializing this class" unless url
    self.class.class_eval do
      base_uri(url)
    end
    @last_result = nil
  end

  def clients
    @last_result = self.class.get('/api/v1/clients.json')
    _clients = @last_result.parsed_response
    clients = []
    _clients.each do |client|
      clients << AssetTrackerConnector::Client.new(client["client"])
    end
    return clients
  end

  def client(guid)
    @last_result = self.class.get("/api/v1/clients/#{guid}.json")
    _client = @last_result.parsed_response
    client = AssetTrackerConnector::Client.new(_client["client"])
    return client
  end
end

module AssetTrackerConnector
  class Client < OpenStruct
  end
end
