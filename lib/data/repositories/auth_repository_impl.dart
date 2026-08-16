import '../../core/interfaces/i_auth_repository.dart';
import '../../core/services/api_service.dart';
import 'dart:convert';

class AuthRepositoryImpl implements IAuthRepository {
  @override
  Future<bool> verifyOtp(String identifier, String otp) async {
    try {
      final response = await ApiService.post(
        '/accounts/user/verify-otp/',
        {
          'email': identifier, // Assuming identifier is email based on Postman
          'otp': otp,
        },
        requireAuth: false,
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> resendOtp(String identifier) async {
    try {
      final response = await ApiService.post(
        '/accounts/user/resend-otp/',
        {
          'email': identifier,
        },
        requireAuth: false,
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
