class AvatarUploader < CarrierWave::Uploader::Base
  include MagickMethods
  
  storage :file

  def store_dir
    "assets/users/#{model.slug}"
  end
  def default_url
    numbername = model.name.mb_chars.downcase.to_s.split('').sum{|char| char.ord}
    numbername -= 22 while numbername > 22
    ActionController::Base.helpers.asset_path '/assets/defaults/avatars/' + numbername.to_s + '.png'
  end
  def extension_white_list; %w(webp jpg jpeg gif png) end  
  def filename
    "avatar.#{model.avatar.file.extension}" if original_filename
  end
  
  version :big_thumb
  version :thumb
  
  def crop_and_resize(c = '192x192+0+0', width = 192)
    w = width.to_s
    Magick.convert model.avatar.to_s, "-crop #{c} +repage -resize #{w}x#{w}", self.to_s
  end  
  
  def resize(source = nil, width = 96)
    source ||= self
    Magick.convert source.to_s, "-resize #{w = width.to_s}x#{w}", self.to_s
  end

end
