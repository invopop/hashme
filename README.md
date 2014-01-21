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
# Our cat class!
class Cat
  include Hashme

  property :name,        String
  property :description, String
end

# Do something with it
kitty = Cat.new(:name => "Catso", :description => "Meows a lot")
kitty.name     # Catso
kitty.to_hash  # {:name => "Catso", :description => "Meows a lot"}
kitty.to_json  # "{\"name\":\"Catso\",\"description\":\"Meows a lot\"}"

kitty2 = Cat.new(kitty.to_hash)
kitty2.to_hash == kitty.to_hash  # true!
````

Models can also be nested, which is probably the most useful part:

````ruby
# A kennel full of kitties
class Kennel
  include Hashme

  property :name,      String
  property :location,  Point
  property :cats,      [Cat]
end

# Build a kennel
kennel = Kennel.new(:name => "Goaway Kitty Home", :location => Point.new(40.333,-3.4555))

# Add a kitten using an object
kennel << kitty

# Add a new cat using a raw hash
kennel << {
  :name => "Felix",
  :description => "Black and white"
}

# Serialize and deserialize to recreate the whole structure
store = kennel.to_hash
kennel = Kennel.new(store)
kennel.cats.length == 2    # true!
````

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

 * Sam Lown <me@samlown.com>

## History

### 0.1.1 - 2014-01-21
 
 * Fixing dependency on ActiveModel >= 3.0

### 0.1.0 - 2014-01-15

 * First release!

