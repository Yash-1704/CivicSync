// Placeholder AuthService - replace with Firebase integration when ready.
class AuthService {
  Future<void> signUpWithPhone(String phone, String password, String role) async {
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> verifyOtp(String verificationId, String otp) async {
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> signIn(String emailOrPhone, String password, String role) async {
    await Future.delayed(Duration(seconds: 1));
  }
}
