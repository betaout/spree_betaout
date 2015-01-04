require 'httparty'

module Betaout
  class API

    include HTTParty
    format :json

    def initialize
      self.class.base_uri "#{Spree::Config.betaout_project_id}.betaout.com"
      @options = { "apiKey" => Spree::Config.betaout_api_key }
    end

    def identify
       self.class.get("/v1/user/identify", @options.merge({}))
    end
  end

  def self.fetch_ott
    API.new.identify.parsed_response["userId"]
  end
end
