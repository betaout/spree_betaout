module Betaout
  class Product

    def initialize(args)
      @spree_product = args[:product]
      @page_url = args[:page_url]
      @picture_url = args[:picture_url]
    end

    def to_hash
      category_hash = {}

      @spree_product.taxons.each do |t|
        category_hash[t.id] = {
          'n' => t.name,
          'p' => t.parent_id,
        }
        t.ancestors.each do |a|
          category_hash[a.id] = {
            'n' => a.name,
            'p' => a.parent_id ? a.parent_id : 0,
          }
        end
      end

      {
        "productId" => @spree_product.id,
        "sku" => @spree_product.sku,
        'productTitle' => @spree_product.name,
        'price' => @spree_product.price.to_s,
        'specialPrice' => '', # TODO: get sale price
        'status' => @spree_product.available? ? "enable" : "disable",
        'stockAvailability' => @spree_product.total_on_hand,
        'pageURL' => @page_url,
        'pictureURL' => @picture_url,
        'currency' => @spree_product.currency,
        'category' => category_hash
      }
    end
  end
end
