fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android setup

```sh
[bundle exec] fastlane android setup
```

Install Flutter dependencies

### android build_debug

```sh
[bundle exec] fastlane android build_debug
```

Build debug APK

### android build_release_apk

```sh
[bundle exec] fastlane android build_release_apk
```

Build release APK

### android build_release

```sh
[bundle exec] fastlane android build_release
```

Build release AAB (App Bundle for Play Store)

### android test

```sh
[bundle exec] fastlane android test
```

Run Flutter tests

### android lint

```sh
[bundle exec] fastlane android lint
```

Run Flutter analyze

### android beta

```sh
[bundle exec] fastlane android beta
```

Deploy to Play Store internal testing track

### android release

```sh
[bundle exec] fastlane android release
```

Promote internal track to production

### android create_keystore

```sh
[bundle exec] fastlane android create_keystore
```

Generate a new upload keystore (run once, store securely)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
