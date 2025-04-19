import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future get({required url, required token});
  Future post({required url, required body, String? token});
}

class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future get({required url, required token}) async {
    return await client.get(
      url, 
      headers: {'Authorization': 'Bearer $token'}
    );
  }

  @override
  Future post({required url, required body, String? token}) async {
    final header = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return await client.post(
      url, 
      body: jsonEncode(body), 
      headers: header
    );
  }
}
