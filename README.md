Paperless
=========

Paperless is a simple Personal Document Management app.

Getting Started
---------------

```
$/paperless/> bundle install --path vendor/bundle
$/paperless/> bundle exec foreman start
```

Build debian package with pkgr
------------------------------

```
bundle exec bin/pkgr package --verbose --force-os "ubuntu-precise" --env CURL_TIMEOUT=1200 --buildpack https://github.com/heroku/heroku-buildpack-ruby.git ../paperless
```