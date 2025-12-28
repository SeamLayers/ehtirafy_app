class AuthApiService {
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Sample success response
    if (email.contains('@') && password.length >= 6) {
      return {
        'success': true,
        'token': 'sample_token_123',
        'userName': 'مستخدم',
      };
    }
    return {
      'success': false,
      'message': 'بيانات غير صحيحة',
    };
  }

  Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    // Sample success response for signup
    if (fullName.isNotEmpty && email.contains('@') && phone.startsWith('+') && password.length >= 8) {
      return {
        'success': true,
        'token': 'sample_token_signup_456',
        'userName': fullName,
      };
    }
    return {
      'success': false,
      'message': 'بيانات غير صحيحة',
    };
  }
}
