Spree::Admin::ProductsController.class_eval do
  create.after :betaout_add_product

  # TODO: does this work? should I expect to see the product in the Betaout admin if no one's viewed it or purchased it yet?
  def betaout_add_product
    Betaout.product_added(@product)
  end
end
