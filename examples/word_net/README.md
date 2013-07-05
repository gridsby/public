Really dumb and simple demo.

How to run
----------

You'll need Ruby >= 1.9 with RubyGems.

You'll also need [Bundler](http://bundler.io/ "Bundler: The best way to manage a Ruby application's gems"). You can install it by running `gem install bundler`.

Then just do:

1. Copy `config/wordnet-demo.yaml.sample` to `config/wordent-demo.yaml`
2. Fill `config/wordnet-demo.yaml` with your OAuth access parameters
3. `bundle install`
4. `ruby app/wordnet.rb`
5. Navigate in browser to http://localhost:4567/tree
