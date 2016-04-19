class LayerUploader < CarrierWave::Uploader::Base
  storage :file
  
  def store_dir
    model.bottle_folder
  end

  version :thumb, if: :is_base? do
    process :resize
  end
  
  def resize(source = self, width = Defaults::BOTTLE[0], height = Defaults::BOTTLE[1])
    Magick.convert source.to_s, "-resize #{w = width}x#{h = height}^ -gravity center -extent #{w}x#{h}", self.to_s
  end

  def extension_white_list; ['png'] end  
  private
  
  def is_base? picture; picture.original_filename == 'base.png' end

end
