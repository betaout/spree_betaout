begin
  Spree::WishedProductsController.class_eval do
    after_filter :betaout_track_product_added_to_wishlist, only: :create, if: "Spree::Betaout::Config.track_via_backend?"

    private

      def betaout_track_product_added_to_wishlist
        Betaout.customer_added_product_to_wishlist({
          session: session,
          product: @wished_product.variant.product,
        })
      end
  end
rescue
end
