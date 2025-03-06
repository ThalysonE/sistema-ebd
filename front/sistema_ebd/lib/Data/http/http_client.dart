import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required url, body, token});
  Future post({required url, required body});
}

class HttpClient implements IHttpClient {
  final client = http.Client();

  Future get({required url, body, token}) async {
    return await client.get(
      Uri.parse(url),
      headers: {'Authorization':'${token}'}
    );
  }
 
  Future post({required url, required body}) async {
    return await client.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
