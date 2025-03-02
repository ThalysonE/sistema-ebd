import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

abstract class IHttpClient{
  Future get({required url});
  Future post({required url, required body});
}

class HttpClient implements IHttpClient{
  final client = http.Client();

  Future get({required url}) async{
    return await client.get(Uri.parse(url));
  }
  Future post({required url, required body}) async{
    return await client.post(
      Uri.parse(url),
      body: jsonEncode(body),
      
    );
  }
  
}