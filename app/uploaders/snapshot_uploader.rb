# encoding: utf-8

class SnapshotUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  storage :file

  version :thumb do
    process resize_to_fit: [280, 280]
  end
  
  def store_dir
    Rails.root.join("store", model.class.to_s.underscore, mounted_as.to_s, model.id.to_s).to_s
  end

  def cache_dir
    Rails.root.join("tmp", "store", model.class.to_s.underscore, mounted_as.to_s, model.id.to_s).to_s
  end

  def extension_white_list
    %w(png jpg)
  end
end
