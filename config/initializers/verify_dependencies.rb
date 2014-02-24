# Verify required binaries are installed on the system
Paperless::DEPENDENCIES = %w(tesseract pdftoppm pdfimages pdftotext)

# Cross-platform way of finding an executable in the $PATH.
# Src: http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
def which(cmd)
  exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
  ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
    exts.each { |ext|
      exe = File.join(path, "#{cmd}#{ext}")
      return exe if File.executable? exe
    }
  end
  return nil
end

Paperless::DEPENDENCIES.each do |binary|
  raise "Paperless needs the '#{binary}' binary in your PATH" unless which(binary)
end