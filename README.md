<p><a target="_blank" href="https://app.eraser.io/workspace/ajpbJwx0o7yCsztjRfkP" id="edit-in-eraser-github-link"><img alt="Edit in Eraser" src="https://firebasestorage.googleapis.com/v0/b/second-petal-295822.appspot.com/o/images%2Fgithub%2FOpen%20in%20Eraser.svg?alt=media&amp;token=968381c8-a7e7-472a-8ed6-4a6626da5501"></a></p>

# Flutter Mobile App Pipelines Infrastructure
This repository contains the infrastructure code for deploying a Flutter mobile app to the Play Store and App Store.

It is an opinionated setup that is focused on using a native Flutter approach to building and deploying the app.
It is also focused on GitOps so that all changes are tracked within this repository.
The only exception is the Fastlane Match certificates and profiles that are stored in a separate repository, depending on your setup.



[﻿View on canvas](https://app.eraser.io/workspace/ajpbJwx0o7yCsztjRfkP?elements=fjepGwUdDRXZelxfFWpaVA) 

## Overview
The Flutter mobile app pipelines are a set of pipelines that are used to build and test the Flutter mobile app.
The pipelines are defined in the `.github/workflows/`directory in the root of this repository.
The pipelines are run on GitHub Actions.

## Prerequisites
The following prerequisites are needed to run the pipelines:

- A GitHub repository
- A Google Play Store account (for ios builds)
- An Apple Developer account (for android builds)
## Pipelines
The following pipelines are defined in this repository:

- `conventional-releases.yml`  - This pipeline is triggered when a new commit is pushed to the `master`  branch.
It runs the `conventional-releases`  action to generate a new GitHub release for the Flutter mobile app.
- `build-android-app.yml`  - This pipeline can be configured to be triggered when the conventional-releases pipeline completes.
You can achieve this by uncommenting the code in the top of the file.
It builds the Flutter mobile app for Android and uploads the Appbundle to the Play Store. It is only set to manual run.
- `build-ios-app.yml`  - This pipeline can be configured to be triggered when the conventional-releases pipeline completes.
You can achieve this by uncommenting the code in the top of the file.
It builds the Flutter mobile app for iOS and uploads the IPA to the App Store. It is only set to manual run.
## Setup
To get started copy the content of this project to your Flutter project.

### Flutter
Get the latest dependencies by running the following command in the root of your Flutter project:

```bash
flutter pub get
```
### Renaming the package name
To rename the package name of your Flutter app, run the following command in the root of your Flutter project:
Change the `com.example.new_package_name` to the package name you want to use.
Change the `My New App Name` to the name you want to use for your app.

```bash
flutter pub global activate rename
flutter pub global run rename --bundleId com.example.new_package_name
flutter pub global run rename --appname "My New App Name"
```
Make sure that all the files in the `android/app/src/main/kotlin/com/example/` directory are moved to the new package name directory and this is added to git.

### Git Hooks
We use Git hooks to enforce commit message formatting and automatically update our release notes.
To install these hooks, run the following command after you clone the repository:

```bash
./install_hooks.sh
```
### Bundler
Make sure you have Ruby installed on your machine.

```bash
ruby -v
```
Install the bundler gem:

```bash
gem install bundler
```
## iOS
>  iOS builds are very expensive to run since they required a Mac to run on.
these are billed with 10x the price of a normal build. 

### Setup iOS
The following steps will help you run the `build-ios-app.yml` pipeline.

Create a new App Store app in the [﻿App Store Connect website](https://appstoreconnect.apple.com/).

#### API Keys
Generate a new App Store API key for the iOS app and store it in the GitHub repository secrets.

- At the [﻿App Store Connect website](https://appstoreconnect.apple.com/access/api) , go to `Users and Access`  and create a new API key.
- Then upload it to the GitHub repository secrets. Repository Settings > Secrets and variables > Actions > New repository secret.
- name: `APP_STORE_CONNECT_API_KEY` 
If you want to run locally you need to store the API key in a file called AuthKey.p8 in the `ios` directory.
Remember to add the file to the `.gitignore` file.

#### Fastlane
Make sure to update the `Appfile` file in the `ios/fastlane` directory.

- `Appfile`  - This file contains the app identifier and the Apple ID of the developer account.
#### Fastlane Match
The iOS app uses [﻿fastlane match](https://docs.fastlane.tools/actions/match/) to manage the certificates and profiles.
To initialize the match repo, run the following command in the `ios` directory:

```bash
bundle exec fastlane match init
```
After following the steps make sure to store the secret(s) in the GitHub repository secrets.
To be accessed by the `build-ios-app.yml` pipeline.

Then run the following command to create the certificates and profiles:

```bash
bundle exec fastlane certs
```
Make sure that you have itc_team_id and team_id in the `Appfile` file in the `ios/fastlane` directory.

Then open Xcode and go to `target` > `Signing & Capabilities` and make sure that the Match certificates and profiles are selected.

#### PodFile
Add the line under the comment to your Podfile to reduce building time. Make sure to update the version tag from time to time.
This will get you the fastest build time possible.

```ruby
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

```bash
bundle exec fastlane certs
```
If needed, add your device to the `devices.txt` file in the `ios/fastlane` directory.

### Running iOS build locally
To run the iOS build locally you need to have a Mac with Xcode installed.

You also need to make sure that you have the API key stored in a file called `AuthKey.p8` in the `ios` directory.

You might also need the key to the repository that contains the Match certificates and profiles.

Then run the following command in the `ios` directory:

```bash
flutter build ios --release --no-codesign --config-only
bundle exec fastlane ios beta
```
## Android
Create a new app in the [﻿Google Play Console](https://play.google.com/apps/publish/).

### API Keys
Create an API key for the Google Play Store.

- At the [﻿Google Play Console](https://play.google.com/apps/publish/)  go to `Setup`  and `API access`  and create a new API key.
- Then upload it to the GitHub repository secrets. Repository Settings > Secrets and variables > Actions > New repository secret.
- name: `PLAY_STORE_CONFIG_JSON` 
### Setup Android Manually
The following steps will help you run the `build-android-app.yml` pipeline if you only copied the files from this repository.

You will need to replace the following classes in your build.gradle file:

```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

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
```
### Fastlane
Make sure to update the `Appfile` file in the `android/fastlane` directory.

### Metadata
Make sure to update the `metadata/android/` directory with the correct metadata for the app.

### Upload key
Generate a new upload key for the Android app and store it in the GitHub repository secrets.

- Follow the steps in the [﻿Android documentation](https://developer.android.com/studio/publish/app-signing#generate-key)  to generate a new upload key.
    - Save the settings in the `android/key.properties`  file.
        - `storePassword` 
        - `keyPassword` 
        - `keyAlias` 
        - `storeFile` 
- Then upload it to the GitHub repository secrets. Repository Settings > Secrets and variables > Actions > New repository secret.
- name: `PLAY_STORE_UPLOAD_KEY` 
- Add each of the other line from the `key.properties`  as separate secrets:
    - `KEYSTORE_KEY_ALIAS` 
    - `KEYSTORE_KEY_PASSWORD` 
    - `KEYSTORE_STORE_PASSWORD` 
Make sure to add `key.properties` and the generated key to the `.gitignore` file.

### Build Android locally
To be able to use the pipeline you have to build and upload the app bundle to the Play Store manually the first time.

This is because the pipeline is dependent on the app bundle name that can only be set when uploading the app bundle to the Play Store.

Make sure you have the following:

- `key.properties`  in your `android`  directory.
- your upload key in the `android/app`  directory.
To build the Android app locally, run the following command in the root of your Flutter project:

```bash
flutter build appbundle --release
```
[﻿Google Play Console](https://play.google.com/apps/publish/). > Your app > Testing > Internal Testing and "Choose signing key"
and select "Use Google-generated key".

Then upload the app bundle to the Play Store.

- Create release > Upload your app bundle. 
- You can find the app bundle in the `build/app/outputs/bundle/release/app-release.aab`  directory.
### Running Android pipeline build locally
Make sure you have the following:

- `key.properties`  in your `android`  directory. 
- your upload key in the `android/app`  directory.
- the API key stored in the `PLAY_STORE_CONFIG_JSON`  env or in a file called `key.json`  in the `android`  directory.
- Export your flutter project path `bash export FLUTTER=$FLUTTER_PATH`  where `$FLUTTER_PATH`  is the path to your flutter installation.
Then run the following command in the `android` directory:

```bash
bundle exec fastlane android internal
```
## Resources
- [﻿Guide](https://keyholesoftware.com/2023/02/13/automating-flutter-deployments-part-2-screenshots/)  on how to set up screenshots for the App Store and Play Store
- [﻿Flutter Integration Test](https://flutter.dev/docs/cookbook/testing/integration/introduction) 
- [﻿Flutter Integration Test Repo](https://github.com/flutter/flutter/blob/master/packages/integration_test/README.md) 
- [﻿emulator](https://pub.dev/packages/emulators) 
- [﻿iOS screenshot sizes](https://appradar.com/blog/ios-app-screenshot-sizes-and-guidelines-for-the-apple-app-store) 
- [﻿iOS emulator Action](https://github.com/marketplace/actions/launch-ios-simulator) 
- [﻿Android emulator Action](https://github.com/marketplace/actions/android-emulator-runner) 
- [﻿PR linter](https://github.com/amannn/action-semantic-pull-request) 



<!--- Eraser file: https://app.eraser.io/workspace/ajpbJwx0o7yCsztjRfkP --->