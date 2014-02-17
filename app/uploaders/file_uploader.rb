# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base  
  storage :file

  def store_dir
    Rails.root.join("store", model.class.to_s.underscore, mounted_as.to_s, model.id.to_s).to_s
  end

  def cache_dir
    Rails.root.join("tmp", "store", model.class.to_s.underscore, mounted_as.to_s, model.id.to_s).to_s
  end

  def extension_white_list
    %w(pdf)
  end
end
