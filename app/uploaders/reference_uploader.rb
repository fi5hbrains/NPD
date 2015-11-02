# encoding: utf-8

class ReferenceUploader < CarrierWave::Uploader::Base
  storage :file
  def store_dir; "assets/polish_reference/#{model.id}" end
  def extension_white_list; %w(jpg jpeg gif png) end
end
