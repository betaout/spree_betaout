require 'httparty'

module Betaout
  class API

    include HTTParty
    format :json
    debug_output $stdout

    def initialize(session = {})
      self.class.base_uri "#{Spree::Config.betaout_project_id}.betaout.com"

      @body_params = {
        'apiKey' => Spree::Config.betaout_api_key,
        'timestamp' => Time.now.to_i,
      }
      @body_params['ott'] = session[:betaout_ott] if session[:betaout_ott].present?

      @email = session[:betaout_email]
      @name = session[:betaout_name]
    end

    def identify
      self.class.get("/v1/user/identify", body: @body_params.merge({name: @name, email: @email}))
    end

    def customer_viewed_product(product)
      puts "in API.customer viewed product"
      body_params = @body_params.merge({
        'email' => @email,
        'action' => 'viewed',
        'products' => [ product ],
      })

      self.class.post("/v1/user/customer_activity", {
        body: 'params=' + body_params.to_json,
      })
    end

    def customer_added_product_to_cart(product, quantity, order)
      product['qty'] = quantity
      body_params = @body_params.merge({
        'email' => @email,
        'action' => 'add_to_cart',
        'products' => [ product ],
        'cartInfo' => {
          'subtotalPrice' => order.item_total,
          #'abandonedCheckoutUrl' => '', # TODO: add this
        },
      })

      self.class.post("/v1/user/customer_activity", {
        body: 'params=' + body_params.to_json,
      })
    end

    def customer_removed_product_from_cart(product, quantity, order)
      product['qty'] = quantity
      body_params = @body_params.merge({
        'email' => @email,
        'action' => 'removed_from_cart',
        'products' => [ product ],
        'cartInfo' => {
          'subtotalPrice' => order.item_total,
          #'abandonedCheckoutUrl' => '', # TODO: add this
        },
      })

      self.class.post("/v1/user/customer_activity", {
        body: 'params=' + body_params.to_json,
      })
    end

    def customer_added_product_to_wishlist(product)
      body_params = @body_params.merge({
        'email' => @email,
        'action' => 'wishlist',
        'products' => [ product ],
      })

      self.class.post("/v1/user/customer_activity", {
        body: 'params=' + body_params.to_json,
      })
    end

    def customer_reviewed_product(product)
      body_params = @body_params.merge({
        'email' => @email,
        'action' => 'reviewed',
        'products' => [ product ],
      })

      self.class.post("/v1/user/customer_activity", {
        body: 'params=' + body_params.to_json,
      })
    end

    def customer_shared_product(product)
      body_params = @body_params.merge({
        'email' => @email,
        'action' => 'shared',
        'products' => [ product ],
      })

      self.class.post("/v1/user/customer_activity", {
        body: 'params=' + body_params.to_json,
      })
    end

    def customer_completed(products, order)
      body_params = @body_params.merge({
        'email' => @email,
        'action' => 'purchased',
        'products' => products,
        'cartInfo' => {
          'orderId' => order.number,
          'subtotalPrice' => order.item_total.to_f,
          'totalShippingPrice' => order.ship_total.to_f,
          'totalTaxes' => order.tax_total.to_f,
          'totalDiscount' => order.promo_total.to_f,
          'totalPrice' => order.total.to_f,
          'financialStatus' => payment_state(order),
        },
      })

      self.class.post("/v1/user/customer_activity", {
        body: 'params=' + body_params.to_json,
      })
    end

    # TODO: does this work? should I expect to see the product in the Betaout admin if no one's viewed it or purchased it yet?
    def product_added(product)
      self.class.post("/v1/product/add", body: @body_params.merge(product).to_json)
    end

    # TODO: does this work? I get a 200 ok response, but doesn't change product name in Betaout admin, for instance
    def product_edited(product)
      self.class.post("/v1/product/edit", body: @body_params.merge(product).to_json)
    end

    def payment_state(order)
      if order.payment_state == 'balance_due'
        #return 'partialy_refund' if order.refunds.any?
        return 'partial_paid' if order.payments.completed.any?
        return 'authorized' if order.payments.pending.any?
        return 'pending' if order.payments.checkout.any?

      elsif order.payment_state == 'paid'
        #return 'refunded' if order.refunds.any?
        return 'paid'

      elsif order.state == 'canceled' && order.payment_total == 0 && payments.completed.none?
        return 'voided'

      else
        return ''
      end
    end
  end

  def self.fetch_ott(session)
    API.new(session).identify.parsed_response["amplifySession"]
  end

  def self.customer_viewed_product(args)
    product_hash = Product.new(args).to_hash
    API.new(args[:session]).customer_viewed_product(product_hash)
  end

  def self.customer_added_product_to_cart(args)
    product_hash = Product.new(args).to_hash
    API.new(args[:session]).customer_added_product_to_cart(product_hash, args[:quantity], args[:order])
  end

  def self.customer_removed_product_from_cart(args)
    product_hash = Product.new(args).to_hash
    API.new(args[:session]).customer_removed_product_from_cart(product_hash, args[:quantity], args[:order])
  end

  def self.customer_added_product_to_wishlist(args)
    product_hash = Product.new(args).to_hash
    API.new(args[:session]).customer_added_product_to_wishlist(product_hash)
  end

  def self.customer_reviewed_product(args)
    product_hash = Product.new(args).to_hash
    API.new(args[:session]).customer_reviewed_product(product_hash)
  end

  def self.customer_shared_product(args)
    product_hash = Product.new(args).to_hash
    API.new(args[:session]).customer_shared_product(product_hash)
  end

  def self.customer_completed(args)

    products = args[:line_items].map do |li|
      product = Product.new(
        product: li[:line_item].product,
        page_url: li[:page_url],
        picture_url: li[:picture_url],
      ).to_hash

      product[:price] = li[:line_item].price.to_s
      product[:qty] = li[:qty]
      product
    end

    API.new(args[:session]).customer_completed(products, args[:order])
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
