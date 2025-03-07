import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required url, required token});
  Future post({required url, required body});
}

class HttpClient implements IHttpClient {
  final client = http.Client();

  Future get({required url, required token}) async {
    return await client.get(
      url,
      headers: {'Authorization':'Bearer ${token}'}
    );
  }
 
  Future post({required url, required body}) async {
    return await client.post(
      Uri.parse(url),
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json',},
    );
  }
}
