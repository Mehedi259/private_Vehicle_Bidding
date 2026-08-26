import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'shared_prefs_service.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator to access host's localhost
  // Use 127.0.0.1 for iOS Simulator or Web
  static const String baseUrl = 'http://13.50.173.212:8001';
  
  static Map<String, String> _headers(bool requireAuth) {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (requireAuth) {
      final token = SharedPrefsService.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    if (_cookies.isNotEmpty) {
      headers['Cookie'] = _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
    }
    return headers;
  }

  static final Map<String, String> _cookies = {};

  static void clearCookies() {
    _cookies.clear();
  }

  static void _updateCookies(http.BaseResponse response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      // Basic cookie parser (handles AWSALB and session cookies)
      // Dates contain commas, so this split might split dates, but the first part
      // (key=value) will still be extracted correctly.
      var parts = rawCookie.split(RegExp(r',(?=[a-zA-Z_]+=)'));
      if (parts.isEmpty) parts = [rawCookie];
      
      for (var part in parts) {
        int index = part.indexOf(';');
        String cookie = (index == -1) ? part : part.substring(0, index);
        var kv = cookie.split('=');
        if (kv.length >= 2) {
          _cookies[kv[0].trim()] = kv.sublist(1).join('=').trim();
        }
      }
      debugPrint('🍪 [API COOKIES UPDATED] $_cookies');
    }
  }

  static void _logRequest(String method, Uri url, Map<String, String> headers, [Object? body]) {
    debugPrint('➡️ [API REQUEST] $method $url');
    debugPrint('➡️ [API HEADERS] $headers');
    if (body != null) {
      debugPrint('➡️ [API BODY] $body');
    }
  }

  static void _logResponse(http.Response response) {
    debugPrint('⬅️ [API RESPONSE] [${response.statusCode}] ${response.request?.url}');
    debugPrint('⬅️ [API BODY] ${response.body}');
  }

  static Future<http.Response> get(String endpoint, {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _headers(requireAuth);
    _logRequest('GET', url, headers);
    final response = await http.get(url, headers: headers);
    _updateCookies(response);
    _logResponse(response);
    return response;
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _headers(requireAuth);
    final bodyStr = jsonEncode(body);
    _logRequest('POST', url, headers, bodyStr);
    final response = await http.post(url, headers: headers, body: bodyStr);
    _updateCookies(response);
    _logResponse(response);
    return response;
  }

  static Future<http.Response> patch(String endpoint, Map<String, dynamic> body, {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _headers(requireAuth);
    final bodyStr = jsonEncode(body);
    _logRequest('PATCH', url, headers, bodyStr);
    final response = await http.patch(url, headers: headers, body: bodyStr);
    _updateCookies(response);
    _logResponse(response);
    return response;
  }

  static Future<http.Response> delete(String endpoint, Map<String, dynamic>? body, {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final headers = _headers(requireAuth);
    final bodyStr = body != null ? jsonEncode(body) : null;
    _logRequest('DELETE', url, headers, bodyStr);
    
    final response = await http.delete(url, headers: headers, body: bodyStr);
    _updateCookies(response);
    _logResponse(response);
    return response;
  }

  static Future<http.StreamedResponse> multipartRequest(
    String method,
    String endpoint, {
    Map<String, String>? fields,
    List<http.MultipartFile>? files,
    bool requireAuth = true,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest(method, url);
    
    if (requireAuth) {
      final token = SharedPrefsService.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (files != null) {
      request.files.addAll(files);
    }

    debugPrint('➡️ [API REQUEST] MULTIPART $method $url');
    debugPrint('➡️ [API HEADERS] ${request.headers}');
    if (fields != null) {
      debugPrint('➡️ [API FIELDS] $fields');
    }
    if (files != null) {
      debugPrint('➡️ [API FILES] ${files.map((e) => e.filename).toList()}');
    }

    final streamedResponse = await request.send();
    _updateCookies(streamedResponse);
    debugPrint('⬅️ [API RESPONSE] MULTIPART [${streamedResponse.statusCode}] $url');
    // We don't read the stream here to avoid consuming it before caller needs it.
    return streamedResponse;
  }
}
