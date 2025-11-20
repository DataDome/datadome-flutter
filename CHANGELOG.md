## 2.0.1 (2025-11-19)

* Fix on issue on iOS where POST HTTP requests could be sent without the expected body when giving a `FlutterStandardTypedData` as the body.

## 2.0.0 (2025-11-06)

* Upgrade `http` dependency version to `^1.0.0`
* Upgrade DataDome Android SDK dependency to `^3.0.0`

### Android requirements
* Minimum API level (`minSdkVersion`): 19
* Minimum Kotlin version: 1.9.0

## 1.2.0

* Add support for HTML challenges 
* Add support for invisible Device Check challenge

## 1.1.0

* Migrate to Android V2
* Upgrade Dart SDK version to be compatible with Dart 3
* Upgrade Kotlin version to 1.6.10
* Upgrade `compileSdkVersion` and `targetSdkVersion` to 32
* Upgrade DataDome SDK Core versions

## 1.0.5

* Support null safety

## 1.0.4

* Fixed an issue when sending map/array in the request body for android.

## 1.0.3

* Fixed an issue when sending map/array in the request body.

## 1.0.2

* Fixed dependencies for android with OkHTTP.

## 1.0.1

* Migrated the repository of the android sdk from Bintray to jitpack.io.

## 1.0.0

* First version of the DataDome Plugin for Flutter. Please visit the documentation for more details on how to integrate and operate the DataDome Flutter plugin.
