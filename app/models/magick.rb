class Magick < ActiveRecord::Base
  
  def self.composite front, back, output = nil, options ='', mask = ''
    output ||= back
    `composite #{self.p(front) + ' ' + self.p(back) + ' ' + self.p(mask) + ' ' + options + ' ' + self.p(output)}`
  end  
  
  def self.convert source, options, output = nil
    output ||= source
    `convert #{self.p(source) + ' ' + options + ' ' + self.p(output)}` 
    puts '---------------------------'
    puts "/usr/local/bin/convert #{self.p(source) + ' ' + options + ' ' + self.p(output)}"
  end  
  
  def self.p name; (/-|\/U/ =~ name[0..1] ? '' :  Rails.root.join('public').to_s ) + name end
  
end
