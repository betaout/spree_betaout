Spree::CheckoutController.class_eval do
  after_filter :betaout_track_customer_completed, only: :update, if: "Spree::Betaout::Config.track_via_backend?"

  private

    def betaout_track_customer_completed
      if @order.completed? && flash['order_completed']
        Betaout.fetch_ott(session)
        Betaout.customer_completed({
          session: session,
          order: @order,
          line_items: @order.line_items.map { |li|
            {
              line_item: li,
              page_url: product_url(li.product),
              picture_url: root_url + li.product.images.first.attachment.url,
              qty: li.quantity,
            }
          },
        })
      end
    end
end
