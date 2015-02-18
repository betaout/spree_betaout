Betaout for Spree
=================

Betaout extension for Spree.

Installation
------------

Add spree_betaout to your Gemfile:

```ruby
gem 'spree_betaout', :git => 'https://github.com/betaout/spree_betaout.git'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g spree_betaout:install
```

Other Extensions
---------------

This extension can track activities supplied by some other popular Spree
extensions:

* spree_wishlist
* spree_email_to_friend
* spree_reviews
* spree_social_products

To track activities from actions supplied by those extensions, install them
according to the instructions supplied with those gems.

Releases
--------

Please visit https://github.com/Betaout/spree_betaout/branches and select
the release that is compatible with your Spree store.

- Release 1.0: Spree 2.X

Copyright (c) 2014 betaout, released under the New BSD License
