abstract class IAuthRepository {
  Future<bool> verifyOtp(String phoneNumber, String otp);
  Future<bool> resendOtp(String phoneNumber);
}
