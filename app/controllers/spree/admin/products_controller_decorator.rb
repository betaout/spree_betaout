Spree::Admin::ProductsController.class_eval do
  create.after :betaout_add_product
  update.after :betaout_edit_product

  def betaout_add_product
    Betaout.product_added(betaout_product_args)
  end

  def betaout_edit_product
    Betaout.product_edited(betaout_product_args)
  end

  private
    def betaout_product_args
      {
        product: @product,
        page_url: product_url(@product),
        picture_url: @product.images.any? ? root_url + @product.images.first.attachment.url : nil,
      }
    end
end
