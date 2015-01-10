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

    def customer_viewed_product(email, product)
      body_params = @body_params.merge({
        'email' => email ? email : '',
        'action' => 'viewed',
        'products' => [ product ],
      })

      self.class.post("/v1/user/customer_activity", {
        body: 'params=' + body_params.to_json,
      })
    end

    # TODO: does this work? should I expect to see the product in the Betaout admin if no one's viewed it or purchased it yet?
    def product_added(product)
      self.class.post("/v1/product/add", body: @body_params.merge(product).to_json)
    end

    def product_edited(product)
      self.class.post("/v1/product/edit", body: @body_params.merge(product).to_json)
    end
  end

  def self.fetch_ott(session)
    API.new(session).identify.parsed_response["amplifySession"]
  end

  def self.customer_viewed_product(args)
    product_hash = Product.new(args).to_hash
    # TODO: add email if/when we have it
    API.new(args[:session]).customer_viewed_product(nil, product_hash)
  end

  def self.product_added(args)
    product_hash = Product.new(args).to_hash
    API.new.product_added(product_hash)
  end

  def self.product_edited(args)
    product_hash = Product.new(args).to_hash
    API.new.product_edited(product_hash)
  end

end
