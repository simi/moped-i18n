# Moped::I18n [![Build Status](https://travis-ci.org/simi/moped-i18n.png?branch=master)](https://travis-ci.org/simi/moped-i18n)

Simple Moped (Mongoid) i18n flattened basic backend implementation.

## Installation

Add this line to your application's Gemfile:

```ruby 
gem 'moped-i18n'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moped-i18n

## Usage

### Moped

```ruby
I18n.backend = I18n::Backend::Moped.new(collections[:i18n])
```

### Mongoid (example)
```ruby
I18n.backend = I18n::Backend::Moped.new(Mongoid.default_session[:i18n])
```

#### Custom model example
```ruby
class Translation
  include Mongoid::Document
  store_in collection: "i18n"

  default_scope order_by(:locale => :asc, :key => :asc)

  field :value
  field :locale
  field :key

  validates :value, presence: true
  validates :locale, presence: true
  validates :key, presence: true, uniqueness: true
  validates_uniqueness_of :key, :scope => :locale

  attr_accessible :value, :key, :locale
end
```

### Chained

If you want mix for example classic simple backend (yaml or ruby hashes) with Mongoid backend.

```ruby
I18n::Backend::Chain.new(I18n::Backend::Moped.new(collections[:i18n])), I18n.backend)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
