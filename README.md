# Hashme

Hashes are great, but sometimes you need a bit more structure.

Hashme helps you create simple models that allow you to initialize and
generate hashes that you can serialize and store as you wish.

Its a bit like ActiveRecord, but without all the messy database stuff,
and of course you can nest to you're heart's content.

A few situations where you might find Hashme useful:

 * parsing incoming data from an API,
 * defining documents that will be stored and reloaded from a file system, or,
 * using a "json" field in a relational database with a bit more structure.

Hashme adheres to ActiveModel and includes support validation, even of nested
attributes with a `valid?` method.

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
  property :dob,         Date
end

# Do something with it
kitty = Cat.new(:name => "Catso", :description => "Meows a lot", :dob => '2012-02-03')
kitty.name     # Catso
kitty.to_hash  # {:name => "Catso", :description => "Meows a lot", :dob => "2012-02-03"}
kitty.to_json  # "{\"name\":\"Catso\",\"description\":\"Meows a lot\",\"dob\":\"2012-02-03\"}"

kitty2 = Cat.new(kitty.to_hash)
kitty2.to_hash == kitty.to_hash  # true!
kitty2.dob.is_a?(Date)           # true!
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

Active Model Validation is included out the box:

````ruby
class User
  include Hashme

  property :name,      String
  property :email,     String

  validates :name, :email, presence: true
end

u = User.new(name: "Sam")
u.valid?           # false !
u.errors.first     # [:email, "can't be blank"]
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

### 0.2.3 - 2016-06-03

 * Fixing bug with validation on CastedArrays

### 0.2.2 - 2016-06-03

 * Removing support for setting attributes without a property.
 * Adding a `attributes=` method.

### 0.2.1 - 2016-06-03

 * Support for embedded document validation.

### 0.2.0 - 2016-06-02

 * Added support for advanced type casting, copy stuff from CouchRest Model.
 * Upgrade to latest rspec version.
 * Removed `Property#cast` and switch to just `Property#build`.

### 0.1.2 - 2014-03-10

 * Set default property values on object initialization.
 * Refactoring to use `class_attribute` for properties hash for improved inheritance.

### 0.1.1 - 2014-01-21
 
 * Fixing dependency on ActiveModel >= 3.0

### 0.1.0 - 2014-01-15

 * First release!

