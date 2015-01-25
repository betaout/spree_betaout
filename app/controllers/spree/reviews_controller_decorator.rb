begin
  Spree::ReviewsController.class_eval do

    after_filter :betaout_track_product_reviewed, only: :create, if: "Spree::Betaout::Config.track_via_backend?"

    private

      def betaout_track_product_reviewed
        unless @review.errors.any?
          Betaout.customer_reviewed_product({
            session: session,
            product: @product,
          })
        end
      end
  end
rescue
end
