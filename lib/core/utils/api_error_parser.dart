import 'dart:convert';

class ApiErrorParser {
  static String parse(dynamic error, {String defaultMessage = 'An error occurred. Please try again.'}) {
    final errorString = error.toString().replaceFirst('Exception: ', '');
    try {
      final data = jsonDecode(errorString);
      
      if (data is Map) {
        if (data.containsKey('non_field_errors')) {
          final errors = data['non_field_errors'];
          if (errors is List && errors.isNotEmpty) {
            return errors.first.toString();
          }
        }
        if (data.containsKey('error')) {
          return data['error'].toString();
        }
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
        if (data.containsKey('detail')) {
          return data['detail'].toString();
        }
        
        // Just return the first value of any list or string found
        for (var value in data.values) {
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }
          if (value is String) {
            return value;
          }
        }
      }
      return defaultMessage;
    } catch (_) {
      if (errorString.isNotEmpty && errorString.length < 200 && !errorString.contains('<!DOCTYPE html>')) {
        return errorString;
      }
      return defaultMessage;
    }
  }
}
