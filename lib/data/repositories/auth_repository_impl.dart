import '../../core/interfaces/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  @override
  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulates validating a 6-digit OTP
    return otp.length == 6;
  }

  @override
  Future<bool> resendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
