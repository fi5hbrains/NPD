module BoxesHelper
  def brand_to_tag brand
    link_to(brand[1])
  end
end
