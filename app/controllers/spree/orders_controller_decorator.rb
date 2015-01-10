Spree::OrdersController.class_eval do
  after_filter :betaout_track_product_added_to_cart, only: [:populate]

  private

    def betaout_track_product_added_to_cart
      logger.debug { "spree_betaout: would track product added to cart:  product: #{@product}" }

      product = Spree::Variant.find(params[:variant_id]).product

      Betaout.customer_added_product_to_cart({
        session: session,
        product: product,
        page_url: product_url(product),
        picture_url: root_url + product.images.first.attachment.url,
        quantity: params[:quantity],
        order: current_order,
      })

    end

end
