# DataDome Flutter Integration
[![Pub](https://img.shields.io/pub/v/datadome.svg)](https://pub.dev/packages/datadome) ![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)

DataDome Flutter plugin is an adaptation of the DataDome `iOS` and `Android` SDKs to Flutter. The plugin provides an interface to make networking requests to ensure your app networking layer is protected with DataDome.
The plugin is mapping the exposed interface to the underlying native SDKs using `URLSession` apis for iOS and `OkHttp` apis for Android.
Displaying the captcha, managing the cookies and handling the event tracker are all managed by the underlying native components.

## Install the plugin
To install the plugin, add the `DataDome` dependency to your `pubspec.yaml` file as shown in the following

```yml
dependencies:
  datadome: ^1.0.0
  flutter:
    sdk: flutter
```


**Note:** Make sure your project does support Swift/Kotlin. If not, enable Swift/Kotlin for your Flutter project by executing the following command

```sh
flutter create -i swift -a kotlin
```

**For iOS:**

Update the `Info.plist` file of the iOS project under `ios/Runner/Info.plist`:

1. Add a new entry with the key `DataDomeKey` and your DataDome client side key as value.
2. Add a new entry with the key `DataDomeProxyEnabled` and NO as value (make sure the type of the entry is Boolean).

Now the plugin is ready to be used.

## Usage
The DataDome Flutter plugin provides a set of APIs to perform networking requests. The plugin will perform a request, intercept any signal from the DataDome remote protection module, display a captcha if relevent and then retry the failed request. 
This is all managed by the DataDome client.

### Initialize the DataDome client
Make sure you create an instance of the DataDome client

```dart
DataDome client = DataDome('YOUR_DATADOME_CLIENT_SIDE_KEY');
```

Depending on the request type, use one of the following APIs from the client instance you just created.
### Perform GET/DELETE requests
Use the `get` or `delete` method from the DataDome client to perform the GET/DELETE request

```dart
Future<http.Response> get({
    @required String url,
    Map<String, String> headers = const {}
}) async
```

```dart
Future<http.Response> delete({
    @required String url,
    Map<String, String> headers = const {}
}) async
```

The method takes the following arguments:

- **url** A string representation of the request URL.
- **headers** An optional Map of header fields and values.

The method executes the request and return a `Response` instance from the [http package](https://pub.dev/packages/http)

Here a **sample code** to perform a GET request

```dart
//importing needed packages
import 'package:datadome/datadome.dart';
import 'package:http/http.dart' as http;

//creating the DataDome client
DataDome client = DataDome('DATADOME_CLIENT_SIDE_KEY');

//performing a GET request
http.Response response = await client.get(url: 'https://datadome.co/wp-json');

//using the response            
print('Response status: ${response.statusCode}');
print('Response headers: ${response.headers}');
print('Response body: ${response.body}');
            
```

### Perform POST/PUT/PATCH requests
Use one of the following methods from the DataDome client to perform the desired request

**POST**

```dart
Future<http.Response> post({
      @required String url,
      Map<String, String> headers = const {},
      body
}) async
```

**PUT**

```dart
Future<http.Response> put({
      @required String url,
      Map<String, String> headers = const {},
      body
}) async
```

**PATCH**

```dart
Future<http.Response> patch({
      @required String url,
      Map<String, String> headers = const {},
      body
}) async
```

The above methods take the following arguments:

- **url** A string representation of the request URL.
- **headers** An optional Map of header fields and values.
- **body** The request body in List or Map data types.

The method executes the request and return a `Response` instance from the [http package](https://pub.dev/packages/http)

Here a **sample code** to perform a POST request

```dart
//importing needed packages
import 'package:datadome/datadome.dart';
import 'package:http/http.dart' as http;

//creating the DataDome client
DataDome client = DataDome('DATADOME_CLIENT_SIDE_KEY');

//performing a POST request
http.Response response = await client.post(url: 'https://jsonplaceholder.typicode.com/posts', body: {'title': 'foo', 'body': 'bar', 'userId': '1'});

//using the response            
print('Response status: ${response.statusCode}');
print('Response headers: ${response.headers}');
print('Response body: ${response.body}');
            
```

## Forcing the Captcha display

To test and validate your integration, use a specific header to force the DataDome remote protection module to block the request and force the underlying native SDK to display the captcha. We use the `User-Agent` header with the value `BLOCKUA` to hint the remote module to block the request.
Please note that the captcha is displayed once and then the generated cookie is stored locally.

Here a **sample code** to perform a GET request while forcing a captcha display

```dart
//importing needed packages
import 'package:datadome/datadome.dart';
import 'package:http/http.dart' as http;

//creating the DataDome client
DataDome client = DataDome('DATADOME_CLIENT_SIDE_KEY');

//performing a GET request with the BLOCKUA User-Agent header
http.Response response = await client.get(url: 'https://datadome.co/wp-json', headers: {'User-Agent': 'BLOCKUA'});

//using the response            
print('Response status: ${response.statusCode}');
print('Response headers: ${response.headers}');
print('Response body: ${response.body}');
            
```

**IMPORTANT** Do not leave this header in production. This will lead all users to see a captcha at least once.