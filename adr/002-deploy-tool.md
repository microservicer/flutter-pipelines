# Title: Adopting Fastlane for Deploying Flutter App

**Status**: Accepted

**Date**: 2023-07-30

## Context
GitHub Actions is not enough for automating the build and deployment process for the Flutter app.
Hand-coding the build and deployment process is time-consuming and error-prone.
Fastlane is a tool that can be used to automate many of the steps in the build and release process.

### Decision Drivers
- Need for consistent and reproducible builds
- Desire to automate repetitive build and deployment tasks
- Support for integrating various tools and services in the CI/CD pipeline
- Compatibility with both iOS and Android platforms

## Considered Options
- **Option 1**: Manual Build Process in GitHub Actions
  - Pros: Full control, no need to learn new tools
  - Cons: Time-consuming, error-prone, not scalable
- **Option 2**: Codemagic
  - Pros: Dedicated Flutter CI/CD, integrates well with Flutter, cloud-based
  - Cons: More limited customization compared to Fastlane, potential cost implications
- **Option 3**: Other Automation Tools
  - Pros: May provide some automation
  - Cons: Limited community support, lack of integration with all required services
- **Option 4**: Fastlane
  - Pros: Strong community support, integration with various tools and services, cross-platform (iOS and Android), well-documented
  - Cons: Learning curve, potential maintenance if heavily customized

## Decision
Selected **Option 4 - Fastlane**, due to its strong community support, extensive integrations, and compatibility with both iOS and Android.
Its ability to automate key aspects of the build process outweighs the initial learning curve, even when compared to dedicated solutions like Codemagic.

## Consequences
- Streamlined and more reliable build and deployment process
- Faster release cycles and quicker time to market
- Dependency on Fastlane's ongoing support and updates
- Initial investment in learning and configuring Fastlane

## Links
[Fastlane Documentation](https://docs.fastlane.tools/)
[Flutter Integration with Fastlane](https://flutter.dev/docs/deployment/fastlane)
[Codemagic Documentation](https://docs.codemagic.io/)