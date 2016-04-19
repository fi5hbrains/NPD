class Magick < ActiveRecord::Base
  
  def self.composite front, back, output = nil, options ='', mask = ''
    output ||= back
    `composite #{self.p(front) + ' ' + self.p(back) + ' ' + self.p(mask) + ' ' + options + ' ' + self.p(output)}`
  end  
  
  def self.convert source, options, output = nil
    output ||= source
    `convert #{self.p(source) + ' ' + options + ' ' + self.p(output)}` 
    Rails.logger.info '---------------------------'
    Rails.logger.info "/usr/local/bin/convert #{self.p(source) + ' ' + options + ' ' + self.p(output)}"
  end  
  
  def self.pngquant filenames
    filenames = [filenames] if filenames.class.name == 'String'
    filenames.each do |f|
    `pngquant #{self.p(f)} --force --ext=.png  `       
    end
  end
  
  def self.p name; (/-|\/U/ =~ name[0..1] || name[0..4] == '/home' ? '' :  Rails.root.join('public').to_s ) + name end
  
end
