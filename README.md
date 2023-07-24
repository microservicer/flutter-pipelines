# Flutter Mobile App Pipelines Infrastructure

This repository contains the infrastructure code for deploying a Flutter mobile app to the Play Store and App Store.

## Overview

The Flutter mobile app pipelines are a set of pipelines that are used to build and test the Flutter mobile app.
The pipelines are defined in the `.github/workflows/`directory in the root of this repository.
The pipelines are run on GitHub Actions.

## Pipelines

The following pipelines are defined in this repository:

- `conventional-releases.yml` - This pipeline is triggered when a new commit is pushed to the `master` branch.
  It runs the `conventional-releases` action to generate a new GitHub release for the Flutter mobile app.
- `build-android-app.yml` - This pipeline can be configured to be triggered when the conventional-releases pipeline completes.
  You can achieve this by uncommenting the code in the top of the file.
  It builds the Flutter mobile app for Android and uploads the Appbundle to the Play Store. It is only set to manual run.
- `build-ios-app.yml` - This pipeline can be configured to be triggered when the conventional-releases pipeline completes.
  You can achieve this by uncommenting the code in the top of the file.
  It builds the Flutter mobile app for iOS and uploads the IPA to the App Store. It is only set to manual run.

## Setup

To get started copy the content of this project to your Flutter project.

### Bundler

Make sure you have Ruby installed on your machine.

``` bash
ruby -v
```

Install the bundler gem:
     
``` bash
gem install bundler
```

## iOS

> iOS builds are very expensive to run since they required a Mac to run on.
these are billed with 10x the price of a normal build.

### Setup iOS

The following steps will help you run the `build-ios-app.yml` pipeline.

#### API Keys

Generate a new App Store API key for the iOS app and store it in the GitHub repository secrets.

- At the [App Store Connect website](https://appstoreconnect.apple.com/access/api), go to `Users and Access` and create a new API key.
- Then upload it to the GitHub repository secrets. Repository Settings > Secrets and variables > Actions > New repository secret.
- name: `APP_STORE_CONNECT_API_KEY`

If you want to run locally you need to store the API key in a file called AuthKey.p8 in the `ios` directory.
Remember to add the file to the `.gitignore` file.

#### Fastlane

Make sure to update the `Appfile` file in the `ios/fastlane` directory.

- `Appfile` - This file contains the app identifier and the Apple ID of the developer account.

#### Fastlane Match

The iOS app uses [fastlane match](https://docs.fastlane.tools/actions/match/) to manage the certificates and profiles.
To initialize the match repo, run the following command in the `ios` directory:

``` bash
bundle exec fastlane match init
```

Following the steps make sure to store the secret(s) in the GitHub repository secrets.
To be accessed by the `build-ios-app.yml` pipeline.

When you have all the details for your Match setup update the `Matchfile` file in the `ios/fastlane` directory.

#### PodFile

Add the line under the comment to your Podfile to reduce building time. Make sure to update the version tag from time to time.
This will get you the fastest build time possible.

``` ruby
target 'Runner' do
  use_frameworks!
  use_modular_headers!

  # Add this row to your Podfile to reduce building time
  pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '10.10.0'
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
```

### Setting up a development profile

To set up a development profile for the iOS app, run the following command in the `ios` directory:

``` bash
bundle exec fastlane certs
```

If needed, add your device to the `devices.txt` file in the `ios/fastlane` directory.

### Running iOS build locally

To run the iOS build locally you need to have a Mac with Xcode installed.

You also need to make sure that you have the API key stored in a file called `AuthKey.p8` in the `ios` directory.

You might also need the key to the repository that contains the Match certificates and profiles.

Then run the following command in the `ios` directory:

``` bash
flutter build ios --release --no-codesign --config-only
bundle exec fastlane ios beta
```

## Android

### Setup Android

The following steps will help you run the `build-android-app.yml` pipeline.

You will need to replace the following classes in your build.gradle file:

``` groovy
android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
    ...
}
    

#### Fastlane

Make sure to update the `Appfile` file in the `android/fastlane` directory.

#### Metadata

Make sure to update the `metadata/android/` directory with the correct metadata for the app.

#### API Keys

Create an API key for the Google Play Store.

- At the [Google Play Console](https://play.google.com/apps/publish/) go to `Setup` and `API access` and create a new API key.
- Then upload it to the GitHub repository secrets. Repository Settings > Secrets and variables > Actions > New repository secret.
- name: `PLAY_STORE_CONFIG_JSON`

#### Upload key

Generate a new upload key for the Android app and store it in the GitHub repository secrets.

- Follow the steps in the [Android documentation](https://developer.android.com/studio/publish/app-signing#generate-key) to generate a new upload key.
  - Save the settings in the `android/key.properties` file.
    - `storePassword`
    - `keyPassword`
    - `keyAlias`
    - `storeFile`
- Then upload it to the GitHub repository secrets. Repository Settings > Secrets and variables > Actions > New repository secret.
- name: `PLAY_STORE_UPLOAD_KEY`
- Add each of the other line from the `key.properties` as separate secrets:
  - `KEYSTORE_KEY_ALIAS`
  - `KEYSTORE_KEY_PASSWORD`
  - `KEYSTORE_STORE_PASSWORD`

Remember to add `key.properties` and the generated key to the `.gitignore` file.

### Running Android build locally

Make sure you have the API Key and Upload key in your `android` directory.

Then run the following command in the `android` directory:

``` bash
bundle exec fastlane android internal
```

## Resources

- [Guide](https://keyholesoftware.com/2023/02/13/automating-flutter-deployments-part-2-screenshots/) on how to set up screenshots for the App Store and Play Store
