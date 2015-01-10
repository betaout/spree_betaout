require 'httparty'

module Betaout
  class API

    include HTTParty
    format :json

    def initialize(session = {})
      self.class.base_uri "#{Spree::Config.betaout_project_id}.betaout.com"

      @body_params = {
        'apiKey' => Spree::Config.betaout_api_key,
        'timestamp' => Time.now.to_i,
      }
      @body_params['ott'] = session[:betaout_ott] if session[:betaout_ott].present?
    end

    def identify
      self.class.get("/v1/user/identify", body: @body_params)
    end
  end

  def self.fetch_ott(session)
    API.new(session).identify.parsed_response["amplifySession"]
  end
end
