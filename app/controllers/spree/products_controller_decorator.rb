Spree::ProductsController.class_eval do
  after_filter :betaout_track_product_viewed, only: [:show], if: "Spree::Betaout::Config.track_via_backend?"

  private

    def betaout_track_product_viewed
      logger.debug { "spree_betaout: would track product viewed:  product: #{@product}" }

      Betaout.customer_viewed_product({
        session: session,
        product: @product,
        page_url: product_url(@product),
        picture_url: @product.images.any? ? root_url + @product.images.first.attachment.url : nil,
      })
    end
end
