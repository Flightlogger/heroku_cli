![Ruby](https://github.com/Flightlogger/heroku_cli/workflows/Ruby/badge.svg)

# HerokuCLI

This gem will wrap the Heroku CLI so it may be used in ruby code

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heroku_cli'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heroku_cli

## Usage

Create a new database in staging that follows the production database and promote it to main DB when ready
```ruby
require 'heroku_cli'

production  = HerokuCLI.application('production')
production_db = production.pg.main

staging = HerokuCLI.application('staging')
staging.pg.create_follower(production_db)
staging.pg.wait
new_db = staging.pg.followers.first
staging.promote(new_db)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bergholdt/heroku_cli. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the HerokuCLI project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bergholdt/heroku_cli/blob/master/CODE_OF_CONDUCT.md).
