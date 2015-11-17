# encoding: utf-8

class ReferenceUploader < CarrierWave::Uploader::Base
  storage :file
  def store_dir; "assets/brands/#{model.brand_slug}/polish/#{model.slug}" end
  def filename
    "reference.#{file.extension}" if original_filename
  end
  def extension_white_list; %w(jpg jpeg gif png) end
end
