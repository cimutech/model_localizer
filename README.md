# ModelLocalizer

This gem is for localize attributes of model.
Simply you could use in this way.

```ruby
  I18n.locale # => 'zh-CN'
  user = User.create(name: '无名', name_en: 'leo')
  user.name # => '无名'
  I18n.locale = 'en'
  user.name # => 'leo'
  user.name_zh_cn # => '无名'
  user.name_en # => 'leo'
```

## Requirements
*  Rails >= 3.2
*  ActiveRecord >= 3.2

## Installation

Add this line to your application's Gemfile:

    gem 'model_localizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install model_localizer

## Getting Started

### 1. Generate Localizer Model

```
rails g model_localizer Localizer
```
Localizer is the default. You can specify any Localizer class as you want.
This generator will auto build an initializer file, and you can config the locales you want.

```ruby
ModelLocalizer.configure do |config|
  # set the locales support by application
  config.locales = ["en", "zh-CN"]
end
```
### 2. Run the migration (only required when using ActiveRecord)

```
rake db:migrate
```

### 3 Configure your user model

This gem adds the `localize` method to your class.

```ruby
class User < ActiveRecord::Base
  localize :name, :description
end
```
You can also work with specify localizer model.

```ruby
class User < ActiveRecord::Base
  localize :name, :description, {:localizer => "Translation"}
end
```

### 4 Go with localize

```ruby
  I18n.locale # => 'zh-CN'
  user = User.create(name: '无名', name_en: 'leo')
  user.name # => '无名'
  I18n.locale = 'en'
  user.name # => 'leo'
  user.name_zh_cn # => '无名'
  user.name_en # => 'leo'
  user.name_en = 'kate' # => 'kate'

  # use ransack for search
  q = {names_value_cont: 'kate'}
  User.ransack(q).result

  # use normal way
  User.joins(:names).where("localizers.value like ?", "%kate%")
```


## Contributing

1. Fork it ( http://github.com/leopoldchen/model_localizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
