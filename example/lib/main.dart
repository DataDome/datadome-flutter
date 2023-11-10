import 'package:flutter/material.dart';
import 'package:datadome/datadome.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('DataDome example app'),
        ),
        body: Center(
          child: MaterialButton(onPressed: () async {
            //make request
            DataDome client = DataDome('client_key');

            http.Client test = http.Client();


            http.Response response = await client.post(url: 'test_url', headers: {'User-Agent': 'BLOCKUA'}, body: []);
            print('Response status: ${response.statusCode}');
            print('Response headers: ${response.headers}');
            print('Response body: ${response.body}');
          },
            child: Text(
              'Make Request'
            ),
          ),
        ),
      ),
    );
  }
}
