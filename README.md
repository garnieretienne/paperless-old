Paperless
=========

Paperless is a simple Personal Document Management app.

Getting Started
---------------

```
$/paperless/> bundle install --path vendor/bundle
$/paperless/> bundle exec foreman start
```

Configuration
-------------

* `TESSERACT_LANGUAGE`: language used by the tesseract OCR engine (default to `eng`)

Development using the Vagrant VM
--------------------------------

You must have [Vagrant](http://www.vagrantup.com/) and [Virtualbox](https://www.virtualbox.org/) installed.

```
$> vagrant up
$> vagrant ssh
$vm> cd /vagrant
$vm> bundle exec foreman start
```

### NFS Sharing

The Vagrant VM can use NFS folder sharing to speed up operations on the virtualized host. You must have access to the `nfsd` binary on the primary host in order to use it (`sudo apt-get install nfs-kernel-server nfs-common` on Ubuntu).

To enable NFS sharing in vagrant for this project use `PAPERLESS_VAGRANT_ENABLE_NFS=true vagrant up`

_**Tip**: if you have the following message `exportfs: Warning: /path/to/your/folder does not support NFS export`, it can be because your shared folder is inside an encrypted folder and NFS does not support it. Move your shared folder inside an unencrypted folder if you want to use NFS sharing._