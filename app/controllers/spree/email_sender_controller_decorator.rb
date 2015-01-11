begin
  Spree::EmailSenderController.class_eval do

    after_filter :betaout_track_product_shared, only: :send_mail

    private

      def betaout_track_product_shared
        if !request.get? && @object.is_a?(Spree::Product) && @mail_to_friend.valid?
          Betaout.customer_shared_product({
            session: session,
            product: @object,
          })
        end
      end
  end
rescue
end
