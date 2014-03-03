# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.network :forwarded_port, :guest => 3000, host: 3000

  if ENV["PAPERLESS_VAGRANT_ENABLE_NFS"] == "true"
    config.vm.network "private_network", :ip => "10.11.12.13"
    config.vm.synced_folder ".", "/vagrant", :type => "nfs"
  else
    config.vm.synced_folder ".", "/vagrant"
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    if !RUBY_PLATFORM.downcase.include?("mswin")
      v.customize ["modifyvm", :id, "--ioapic", "on"]
      v.customize ["modifyvm", :id, "--cpus", `grep "^processor" /proc/cpuinfo | wc -l`.chomp ]
    end
  end

  bootstrap_script = <<-SCRIPT

    echo ""
    echo ">> Install dependencies"
    echo ""

    sudo apt-get update --assume-yes
    sudo apt-get install --assume-yes git curl libyaml-dev libssl-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev build-essential

    echo ""
    echo ">> Installing rbenv and rvm-download"
    echo ""

    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile
    echo 'eval "$(rbenv init -)"' >> ~/.profile
    git clone https://github.com/garnieretienne/rvm-download.git ~/.rbenv/plugins/rvm-download
    source ~/.profile

    ruby_version=`cat /vagrant/.ruby-version`

    echo ""
    echo ">> Installing ruby ${ruby_version}"
    echo ""

    rbenv download $ruby_version
    rbenv global $ruby_version
    rbenv rehash

    echo ""
    echo ">> Building bundler gem"
    echo ""

    gem install bundler
    rbenv rehash

    echo ""
    echo ">> Install app dependencies"
    echo ""

    sudo apt-get install --assume-yes redis-server imagemagick tesseract-ocr poppler-utils tesseract-ocr-fra
    
    echo ""
    echo ">> Run 'bundle install'"
    echo ""

    cd /vagrant
    bundle install --path vendor/bundle

    echo ""
    echo ">> Run database migrations"
    echo ""

    bundle exec rake db:setup

    echo ""
    echo ">> Done."
    echo "   You can start the app running 'bundle exec foreman start' inside the"
    echo "   '/vagrant' folder."
  SCRIPT
  config.vm.provision "shell", :inline => bootstrap_script, :keep_color => true, :privileged => false

end
