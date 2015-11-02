module PolishesHelper
  def bottle_or_spinner image_url, is_bottled, html = {}
    if params[:spinner] != 'force' && is_bottled 
      image_tag image_url, class: html[:class]
    else
      image_tag 'spinner_b.svg', class: html[:class].to_s + ' getBottlingStatus'
    end
  end
  
  def link_to_add_layer(type, f)
    layer = PolishLayer.new(layer_type: type)
    id = layer.object_id
    fields = f.fields_for(:layers, layer, child_index: id) do |ff|
      render 'layer_fields', l: layer, l_f: ff, f: f
    end
    link_to( type, '#', class: "add_layer", data: {id: id, fields: fields.gsub("\n", "").gsub("class='layer'","class='layer' style='display:none'")})
  end
end
