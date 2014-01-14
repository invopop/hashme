# Hashme

Hashes are great, but sometimes you need a bit more structure.

Hashme helps you create simple models that allow you to initialize and
generate hashes that you can serialize and store as you wish.

Its a bit like ActiveRecord, but without all the messy database stuff,
and of course you can nest to you're hearts content.

## Installation

Add this line to your application's Gemfile:

    gem 'hashme'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hashme

## Usage

Create a class, include the `Hashme` module, and define some properties:

````ruby
class Cat
  include Hashme

  property :name
  property :description

end
````


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

 * Sam Lown <me@samlown.com>
