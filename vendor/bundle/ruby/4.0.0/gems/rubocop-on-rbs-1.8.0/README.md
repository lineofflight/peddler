# RuboCop on RBS

A [RuboCop](https://github.com/rubocop/rubocop) extension focused on enforcing [RBS](https://github.com/ruby/rbs) best practices and coding conventions.

## Synopsis

Now, We can support RBS files by rubocop.

```console
$ cat sig/foo.rbs
module Foo
def foo: (   void) -> untyped
end

$ bundle exec rubocop sig/foo.rbs
Inspecting 1 file
W

Offenses:

sig/foo.rbs:2:1: C: [Correctable] RBS/Layout/IndentationWidth: Use 2 (not 0) spaces for indentation.
def foo: (   void) -> untyped

sig/foo.rbs:2:11: C: [Correctable] RBS/Layout/ExtraSpacing: Unnecessary spacing detected.
def foo: (   void) -> untyped
          ^^
sig/foo.rbs:2:14: W: RBS/Lint/WillSyntaxError: void type is only allowed in return type or generics parameter
def foo: (   void) -> untyped
             ^^^^

1 file inspected, 3 offenses detected, 2 offenses autocorrectable
```

## Support VSCode

[vscode-rubocop](https://github.com/rubocop/vscode-rubocop) with [rubocop.additionalLanguages](https://github.com/rubocop/vscode-rubocop?tab=readme-ov-file#rubocopadditionallanguages) option is recommended.

```json
"rubocop.additionalLanguages": ["rbs"]
```

Additionally, by configuring the `settings.json` below, you can enable auto-correction to run on file save.

```json
{
    "[rbs]": {
        "editor.formatOnSave": true,
        "editor.defaultFormatter": "rubocop.vscode-rubocop"
    },
}
```

And restart VSCode.

## Departments

You can see documentation for all cops.

https://github.com/ksss/rubocop-on-rbs/blob/main/docs/modules/ROOT/pages/cops.adoc

### RBS

This gem handles many cops.
All cops can be enabled by following setting by default.

```yaml
RBS:
  Enabled: true
```

### RBS/Layout

This department is a collection of relatively minor fixes has been gathered.

```yaml
RBS/Layout:
  Enabled: true
```

```console
$ bundle exec rubocop --only RBS/Layout
```

### RBS/Lint

This department is gathering important points that need to be fixed.

```yaml
RBS/Lint:
  Enabled: true
```

```console
$ bundle exec rubocop --only RBS/Lint
```

### RBS/Style

This department unifies multiple styles.

```yaml
RBS/Style:
  Enabled: true
```

```console
$ bundle exec rubocop --only RBS/Style
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add rubocop-on-rbs --require false

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install rubocop-on-rbs

## Usage

You need to tell RuboCop to load the RBS extension. There are three
ways to do this:

### RuboCop configuration file

Put this into your `.rubocop.yml`.

```yaml
plugins: rubocop-on-rbs
```

Alternatively, use the following array notation when specifying multiple extensions.

```yaml
plugins:
  - rubocop-other-extension
  - rubocop-on-rbs
```

Now you can run `rubocop` and it will automatically load the RuboCop on RBS
cops together with the standard cops.

> [!NOTE]
> The plugin system is supported in RuboCop 1.72+. In earlier versions, use `require` instead of `plugins`.

### Command line

```sh
$ rubocop --plugin rubocop-on-rbs
```

### Rake task

```ruby
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.plugins << 'rubocop-on-rbs'
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ksss/rubocop-on-rbs. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/ksss/rubocop-on-rbs/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RuboCop on RBS project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ksss/rubocop-on-rbs/blob/main/CODE_OF_CONDUCT.md).
