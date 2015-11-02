module MagickMethods
  
  def fill colour
    c = Defaults::CANVAS
    "-size #{c[0]}x#{c[1]} canvas:'#{colour}'"
  end
  
  def coat filename, i; filename.gsub('.png', i == 0 ? '' : "_x#{i + 1}") + '.png' end
  def add_plus n; n >= 0 ? '+' + n.to_s : n.to_s end
  def path; Rails.root.join('public').to_s end
  def p name; (/-|\/U/ =~ name[0..1] ? '' : path) + name end
  
  private :path, :p  
  
end