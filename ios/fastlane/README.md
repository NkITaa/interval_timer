fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios setup

```sh
[bundle exec] fastlane ios setup
```

Install dependencies (Flutter pub get + CocoaPods)

### ios build_debug

```sh
[bundle exec] fastlane ios build_debug
```

Build debug (no codesign)

### ios build_release

```sh
[bundle exec] fastlane ios build_release
```

Build release IPA

### ios test

```sh
[bundle exec] fastlane ios test
```

Run Flutter tests

### ios lint

```sh
[bundle exec] fastlane ios lint
```

Run Flutter analyze

### ios beta

```sh
[bundle exec] fastlane ios beta
```

Deploy to TestFlight

### ios release

```sh
[bundle exec] fastlane ios release
```

Deploy to App Store

### ios bump_build

```sh
[bundle exec] fastlane ios bump_build
```

Bump build number in pubspec.yaml (uses latest TestFlight build + 1)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
