# Huanxin
环信 ruby sdk.

## Installation

### 基本配置
 rails_app/config/initializers/huanxin.rb
```ruby
Huanxin.configure do |config|
  config.org = ''
  config.app = ''
  config.host = 'https://a1.easemob.com'
  config.client_id = ''
  config.client_secret = ''
  config.log_level = :warn
  config.log_file = "#{Rails.root}/log/Huanxin.log"
end
```

Add this line to your application's Gemfile:

```ruby
gem 'huanxin', github: 'yeluojun/haunxin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install huanxin

## Usage

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/huanxin.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

