# Title: Package renaming tool

**Status**: Accepted

**Date**: 2023-07-30

## Context
To be able to quickly change to the new app package name we want to use a well-tested tool for this.

### Decision Drivers
- Package renaming has to be easy.

## Considered Options
- **rename**: Version ^2.1.1
    - Pros: over 750 up votes
    - Pros: Have functionality to rename on different platforms
    - Cons: Requires multiple steps
- **change_app_package_name**: Version ^0.1.2
    - Pros: Over 1000 up votes
    - Pros: Only one step required
    - cons: Only updates the Android package name

## Decision
Selected **rename** for its functionality to change the package name on different platforms.

## Consequences
- We depend on this package to be up-to-date with the Flutter platform and the different app stores.

## Links
[rename on pub.dev](https://pub.dev/packages/rename)
[change_app_package_name on pub.dev](https://pub.dev/packages/change_app_package_name)
