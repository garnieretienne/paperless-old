module Paperless

  class Store
    FOLDER = Rails.root.join('store', Rails.env)

    def self.path
      FOLDER
    end

    def self.verify_store_folder
      Dir.mkdir(FOLDER, 0700) unless Dir.exist? FOLDER
    end
    
    def self.put(file_path, file_name)
      verify_store_folder

      File.open(file_path, 'r') do |src|
        File.open("#{FOLDER}/#{file_name}", 'wb') do |dst|
          dst.write(src.read)
        end
      end
      file_name
    end

    def self.get_path(file_name)
      "#{FOLDER}/#{file_name}"
    end
  end
end