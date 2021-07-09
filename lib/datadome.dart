
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class DataDome {
  static const MethodChannel _channel = const MethodChannel('datadome');
  String key;

  /// A public constructor of the DataDome client.
  /// The DataDome client side key is to be provided as [String].
  ///
  /// The constructor will create an instance of the client and hold
  /// a reference to the client side key.
  DataDome(this.key) {
    this.key = key;
  }

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  /// The url should be a [String].
  /// The headers should be a [Map<String, String>].
  ///
  /// This method executes and return a [http.Response] instance.
  Future<http.Response> get({
    required String url,
    Map<String, String> headers = const {}}) async {

    return _request(_HttpMethod.get, url, headers, null);
  }

  /// Sends an HTTP DELETE request with the given headers to the given URL.
  /// The url should be a [String].
  /// The headers should be a [Map<String, String>].
  ///
  /// This method executes and return a [http.Response] instance.
  Future<http.Response> delete({
    required String url,
    Map<String, String> headers = const {}}) async {

    return _request(_HttpMethod.delete, url, headers, null);
  }

  /// Sends an HTTP POST request with the given headers and body to the given URL.
  /// The url should be a [String].
  /// The headers should be a [Map<String, String>].
  /// The body can be a List or a Map.
  ///
  /// This method executes and return a [http.Response] instance.
  Future<http.Response> post({
      required String url,
      Map<String, String> headers = const {},
      body}) async {

    return _request(_HttpMethod.post, url, headers, body);
  }

  /// Sends an HTTP PUT request with the given headers and body to the given URL.
  /// The url should be a [String].
  /// The headers should be a [Map<String, String>].
  /// The body can be a List or a Map.
  ///
  /// This method executes and return a [http.Response] instance.
  Future<http.Response> put({
      required String url,
      Map<String, String> headers = const {},
      body}) async {

    return _request(_HttpMethod.put, url, headers, body);
  }

  /// Sends an HTTP PATCH request with the given headers and body to the given URL.
  /// The url should be a [String].
  /// The headers should be a [Map<String, String>].
  /// The body can be a List or a Map.
  ///
  /// This method executes and return a [http.Response] instance.
  Future<http.Response> patch({
      required String url,
      Map<String, String> headers = const {},
      body}) async {

    return _request(_HttpMethod.patch, url, headers, body);
  }

  /// Sends a HTTP request with the given headers and body to the given URL.
  /// The url should be a [String].
  /// The headers should be a [Map<String, String>].
  /// The body can be a List or a Map.
  ///
  /// This method executes the request using the underlying native SDKs
  /// and creates a [http.Response] instance accordingly.
  Future<http.Response> _request(
      _HttpMethod method,
      String url,
      Map<String, String> headers,
      body,
      ) async {

    final args = {
      'csk': this.key,
      'method': describeEnum(method),
      'url': url,
      'headers': headers,
      'body': body
    };

    final Map<String, dynamic> response = await (_channel.invokeMapMethod('request', args) as FutureOr<Map<String, dynamic>>);
    Map<String, String> responseHeaders = new Map<String, String>.from(response['headers']);
    http.Response httpResponse = http.Response.bytes(
        response['data'],
        response['code'],
        headers: responseHeaders
    );

    return httpResponse;
  }
}

/// An enumeration of all supported HTTP Methods.
/// Supported verbs are GET, DELETE, POST, PUT and PATCH
enum _HttpMethod {
  get,
  delete,
  post,
  put,
  patch
}