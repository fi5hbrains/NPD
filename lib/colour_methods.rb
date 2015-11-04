module ColourMethods
  def get_alpha colour
    if a = colour =~ /[0-9a-fA-F]{8}/
      colour[a,8][-2,2].to_i(16).to_s
    elsif colour =~ /[0-9a-fA-F]{4}/
      (colour[a,4][-1]*2).to_i(16).to_s
    elsif colour =~ /(\d{1,3}), *(\d{1,3}), *(\d{1,3})/
      ((colour.split(',')[3].gsub(')','') || 1).to_f * 100).round.to_s       
    end
  end
  
  def colour_to_hsl colour, spread = nil
    if colour
      if colour.class.name == 'Array'
        colour
      elsif Defaults::COLOURS.values.map(&:keys).sum.include?( colour.mb_chars.downcase.to_s )
        colours = {}
        Defaults::COLOURS.values.each{|c| colours.merge!(c)}
        colour = colours[colour.mb_chars.downcase.to_s]
        if spread
          h = colour[:h2] ? colour[:h].max - (colour[:h].max + 360 - colour[:h2].min) / 2 : middle(colour[:h])
          h = 360 + h if h < 0
          [h, middle( colour[:s]), middle( colour[:l]) ]
        else
          colour
        end
      elsif colour =~ /(\d{1,3}), *(\d{1,3}), *(\d{1,3})/
        rgbdec_to_hsl colour
      elsif colour =~ /[0-9a-fA-F]{3}/
        rgbhex_to_hsl colour
      end
    else 
      false
    end
  end
  
  def colour_to_hsl_range colour, spread = nil
    if hsl = colour_to_hsl( colour, spread )
      spread ||= 10
      spread = spread.to_i
      if hsl.class.name == 'Hash'
        h = hsl[:h]
        h2 = hsl[:h2]
        s = hsl[:s]
        l = hsl[:l]
        o = (hsl[:o] || 1) * 100.0
      elsif hsl[0] - spread < 0
        h = 0 .. hsl[0] + spread
        h2 = 360 + hsl[0] - spread .. 360
      elsif hsl[0] + spread > 360
        h = hsl[0] - spread .. 360
        h2 = 0 .. spread - 360 + hsl[0]
      else
        h = hsl[0] - spread .. hsl[0] + spread
        h2 = nil
      end
      s = hsl[1] - spread .. hsl[1] + spread
      l = hsl[2] - spread * 2 .. hsl[2] + spread * 2
      opacity = hsl[3].blank? ? 100 : hsl[3].class.name == 'Float' ? hsl[3] * 100 : hsl[3]
      o = opacity - spread .. opacity + spread
    else
      h = h2 = s = l = o = nil      
    end  
    return {h: h, h2: h2, s: s, l: l, o: o}
  end
  
  def rgbhex_to_hsl rgb
    rgbdec_to_hsl( rgb_hex_to_dec(rgb) )
  end

  def rgbdec_to_hsl rgb
    calculate_colours( rgb.gsub('rgba(','').gsub('rgb(','').gsub(')','').split(',').map {|c| c.to_f} )
  end
  
  def rgb_hex_to_dec hex
    hex = hex.gsub('#','')
    dec = (hex.length.between?(3,4) ? hex.scan(/./).map{|c| (c*2).to_i(16)} : hex.length.between?(6,8) ? hex.scan(/../).map{|c| c.to_i(16)} : [255,255,255])
    return "rgba(#{dec[0]},#{dec[1]},#{dec[2]}, #{dec[3] ? dec[3] / 255.0 : 1})"
  end
  
  def calculate_colours rgb
    r = (rgb[0]/255.0); g = (rgb[1]/255.0); b = (rgb[2]/255.0)
    max = [r,g,b].max
    min = [r,g,b].min
    l = (max + min) / 2
    if max == min 
      h = s = 0
    else
      d = (max - min)
      s = (l > 0.5 ? d / (2 - max - min) : d / (max + min))
      case max
      when r; h = (g - b) / d + (g < b ? 6 : 0)
      when g; h = (b - r) / d + 2
      when b; h = (r - g) / d + 4
      end
      h /= 6
    end
    return [(h*360).round,(s*100).round,(l*100).round, rgb[3]]
  end
  private
  
  def middle range
    (range.min + range.max) / 2
  end
end
