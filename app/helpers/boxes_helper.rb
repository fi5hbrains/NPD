module BoxesHelper
  def brand_to_tag brand
    check_box_tag('filter_brand[' + brand[0] + ']', nil, nil, class: '', 'data-updatable' => true) + label_tag('filter_brand[' + brand[0] + ']',brand[1], class: 'tag')
  end
end
