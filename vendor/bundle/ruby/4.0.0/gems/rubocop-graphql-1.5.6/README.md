# RuboCop::GraphQL ![](https://ruby-gem-downloads-badge.herokuapp.com/rubocop-graphql?type=total)

[Rubocop](https://github.com/rubocop-hq/rubocop) extension for enforcing [graphql-ruby](https://github.com/rmosolgo/graphql-ruby) best practices.

You can support my open–source work [here](https://boosty.to/dmitry_tsepelev).

## Installation

Install the gem:

```bash
gem install rubocop-graphql
```

If you use bundler put this in your Gemfile:

```ruby
gem 'rubocop-graphql', require: false
```

## Usage

You need to tell RuboCop to load the GraphQL extension. There are three ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```yaml
plugins: rubocop-graphql
```

Alternatively, use the following array notation when specifying multiple extensions.

```yaml
plugins:
  - rubocop-other-extension
  - rubocop-graphql
```

Now you can run `rubocop` and it will automatically load the RuboCop GraphQL cops together with the standard cops.

> [!NOTE]
> The plugin system is supported in RuboCop 1.72+. In earlier versions, use `require` instead of `plugins`.

### Command line

```sh
rubocop --plugins rubocop-graphql
```

### Rake task

```ruby
RuboCop::RakeTask.new do |task|
  task.plugins << 'rubocop-graphql'
end
```

## The Cops

All cops are located under [`lib/rubocop/cop/graphql`](lib/rubocop/cop/graphql), and contain examples and documentation.

In your `.rubocop.yml`, you may treat the GraphQL cops just like any other cop. For example:

```yaml
GraphQL/ResolverMethodLength:
  Max: 3
```

## Credits

Initially sponsored by [Evil Martians](http://evilmartians.com).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/DmitryTsepelev/rubocop-graphql.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
