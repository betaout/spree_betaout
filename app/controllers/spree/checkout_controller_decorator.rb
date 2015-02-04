Spree::CheckoutController.class_eval do
  after_filter :betaout_track_customer_completed, only: :update, if: "Spree::Betaout::Config.track_via_backend?"

  private

    def betaout_track_customer_completed
    logger.debug "spree_betaout: checkout complete, so fetching it"
      if @order.completed? && flash[:commerce_tracking]
         logger.debug "spree_betaout: checkout complete,insert"
        Betaout.fetch_ott(session)
        Betaout.customer_completed({
          session: session,
          order: @order,
          line_items: @order.line_items.map { |li|
            {
              line_item: li,
              page_url: product_url(li.product),
              picture_url: li.product.images.any? ? root_url + li.product.images.first.attachment.url : nil,
              qty: li.quantity,
            }
          },
        })
      end
    end
end
