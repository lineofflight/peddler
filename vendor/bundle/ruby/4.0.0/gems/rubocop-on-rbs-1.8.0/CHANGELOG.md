## [Unreleased]

* Pluginfy RuboCop on RBS by @ydah in https://github.com/ksss/rubocop-on-rbs/pull/88

## [1.4.2] - 2025-02-23

* [RBS/Style/ClassWithSingleton] Digging into each types by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/84
* [RBS/Style/InstanceWithInstance] Digging into each types by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/83

## [1.4.1] - 2025-02-23

* Default type params allows void by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/82

## [1.4.0] - 2025-02-23

* Bundle update by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/71
* Improve will syntax error by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/73
* [RBS/Lint/WillSyntaxError] Support Proc self_type by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/74
* Add RBS/Lint/NewReturnsVoid by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/79
* Bundle update by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/80
* Enabled pending cops by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/81
* Use Ruby 3.4 on CI by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/72

## [1.3.0] - 2024-12-24

* Add RBS/Lint/AmbiguousKeywordArgumentKey by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/51
* Fix false positive for TopLevel* by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/52
* Support `RBS::AST::Members::Var` by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/53
* [RBS/Layout/SpaceAroundOperators] Support other declarations by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/54
* Support other declarations by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/55
* Use 3.4.0-rc1 by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/56
* Add RBS/Lint/UselessTypeAliasTypeParams by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/57
* Use "Unused" instead of "Useless" as much as possible. by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/58
* Check config/default.yml on CI by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/59
* Use "Unused" instead of "Useless" as much as possible. by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/60
* Add RBS/Layout/SpaceAfterComma by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/61
* Add RBS/Style/InstanceWithInstance by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/62
* Introduce rbs-inline by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/63
* Reimplement RBS/Style/InstanceWithInstance  by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/64
* Add RBS/Style/ClassWithSingleton by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/65

## [1.2.0] - 2024-11-18

* Fix false positive when oneline class by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/41
* Add RBS/Lint/TopLevelTypeAlias by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/46
* Add RBS/Lint/TopLevelInterface by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/47
* [RBS/Lint/TopLevelTypeAlias] Fix false positive by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/48
* Bundle update by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/49

## [1.1.0] - 2024-10-01

* Add RBS/Layout/EmptyLinesAroundAccessModifier by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/39
* Fix error when same line with `RBS/Layout/EndAlignment` by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/40

## [1.0.0] - 2024-09-17

* Add RBS/Layout/EmptyLines by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/35
* Fix doc for EmptyLinesAroundOverloads by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/36
* Add Layout/EmptyLinesAround{Class,Module}Body by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/37
* Add RBS/Layout/EmptyLinesAroundInterfaceBody by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/38

## [0.9.0] - 2024-08-07

* Fix error if includes multibyte characters by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/31

## [0.8.0] - 2024-08-06

* Fix use of argument in upper_bound by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/24
* Security update by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/29

## [0.7.0] - 2024-06-27

* Add RBS/Lint/AmbiguousOperatorPrecedence by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/22
* Add RBS/Lint/UselessAccessModifier by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/23

## [0.6.0] - 2024-06-18

* Fixed problems interfering with other Cop by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/20

## [0.5.0] - 2024-06-17

* Fix destructive change by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/17
* Introduce cache by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/18
* Fix bug for EmptyArgument by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/19

## [0.4.0] - 2024-06-14

* Split RuboCop task by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/6
* Ignore when return untyped by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/7
* Split task for steep by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/8
* Add Style/EmptyArgument by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/9
* Allow return variable only to use by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/10
* Remove Style/MergeUntyped by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/11
* Remove Lint/TypeParamsArity by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/12
* Regenerate docs by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/13
* Add RBS/Layout/SpaceAroundOperators by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/14
* Add RBS/Style/RedundantParentheses by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/15
* Add RBS/Lint/LiteralIntersection by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/16

## [0.3.0] - 2024-06-11

* Implement RedundantOverloadTypeParams instead of UselessOverloadTypeParams by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/1
* Introduce RBS/Lint/DuplicateOverload by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/2
* Fix typo by @ydah in https://github.com/ksss/rubocop-on-rbs/pull/3
* Remove unnecessary Exclude settings in  .rubocop.yml by @ydah in https://github.com/ksss/rubocop-on-rbs/pull/4
* Generate docs for cop by @ksss in https://github.com/ksss/rubocop-on-rbs/pull/5

## [0.1.0] - 2024-05-15

- Initial release
