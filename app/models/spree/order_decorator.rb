Spree::Order.class_eval do
  def tax_total
    included_tax_total + additional_tax_total
  end
end
