Spree::ProductsController.class_eval do
  after_filter :betaout_track_product_viewed

  private

    def betaout_track_product_viewed
      logger.debug { "spree_betaout: would track product viewed:  product: #{@product}" }

      Betaout.customer_viewed_product({
        session: session,
        product: @product,
        page_url: product_url(@product),
        picture_url: root_url + @product.images.first.attachment.url,
      })
    end
end
