Spree::OrdersController.class_eval do
  after_filter :betaout_track_product_added_to_cart, only: :populate, if: "Spree::Betaout::Config.track_via_backend?"
  around_filter :betaout_track_product_removed_from_cart, only: :update, if: "Spree::Betaout::Config.track_via_backend?"

  private

    def betaout_track_product_added_to_cart
      logger.debug { "spree_betaout: would track product added to cart:  product: #{@product}" }

      product = Spree::Variant.find(params[:variant_id]).product

      Betaout.customer_added_product_to_cart({
        session: session,
        product: product,
        page_url: product_url(product),
        picture_url: product.images.any? ? root_url + product.images.first.attachment.url : nil,
        quantity: params[:quantity],
        order: current_order,
      })
    end

    def betaout_track_product_removed_from_cart
      logger.debug "In track product removed from cart"
      products_being_removed = []

      params[:order][:line_items_attributes].each do |index, line_item|
        if line_item[:quantity] == "0"
          line_item = Spree::LineItem.find(line_item[:id])
          products_being_removed << {
            product: line_item.variant.product,
            original_quantity: line_item.quantity,
          }
        end
      end

      yield

      products_being_removed.each do |p|
        Betaout.customer_removed_product_from_cart({
          session: session,
          product: p[:product],
          quantity: p[:original_quantity],
          order: current_order,
        })
      end
    end
end
