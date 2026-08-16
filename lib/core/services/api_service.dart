import 'dart:convert';
import 'package:http/http.dart' as http;
import 'shared_prefs_service.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator to access host's localhost
  // Use 127.0.0.1 for iOS Simulator or Web
  static const String baseUrl = 'http://127.0.0.1:8000'; 
  
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
    return headers;
  }

  static Future<http.Response> get(String endpoint, {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.get(url, headers: _headers(requireAuth));
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.post(
      url,
      headers: _headers(requireAuth),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> patch(String endpoint, Map<String, dynamic> body, {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    return await http.patch(
      url,
      headers: _headers(requireAuth),
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> delete(String endpoint, Map<String, dynamic>? body, {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    if (body != null) {
       return await http.delete(
        url,
        headers: _headers(requireAuth),
        body: jsonEncode(body),
      );
    }
    return await http.delete(url, headers: _headers(requireAuth));
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

    return await request.send();
  }
}
