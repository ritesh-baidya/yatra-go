import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../../core/token_storage.dart';

class AuthResult {
  final bool isNewUser;
  final bool mfaRequired;
  final String? mfaToken;
  final Map<String, dynamic>? user;

  AuthResult({
    required this.isNewUser,
    required this.mfaRequired,
    this.mfaToken,
    this.user,
  });
}

class AuthApi {
  AuthApi._();
  static final AuthApi instance = AuthApi._();

  final Dio _dio = ApiClient.instance.dio;

  /// Sends a 6-digit OTP to the given phone number.
  /// [phoneNumber] must be E.164 Nepal format, e.g. `+9779800000000`.
  Future<void> sendOtp(String phoneNumber) async {
    try {
      await _dio.post('/auth/send-otp', data: {'phoneNumber': phoneNumber});
    } on DioException catch (e) {
      throw _messageFrom(e);
    }
  }

  /// Verifies the OTP. On success (no MFA) tokens are persisted.
  Future<AuthResult> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/verify-otp',
        data: {'phoneNumber': phoneNumber, 'otp': otp},
      );
      final data = response.data['data'] as Map<String, dynamic>;

      if (data['mfaRequired'] == true) {
        return AuthResult(
          isNewUser: false,
          mfaRequired: true,
          mfaToken: data['mfaToken'] as String?,
        );
      }

      await TokenStorage.instance.saveTokens(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );

      return AuthResult(
        isNewUser: data['isNewUser'] == true,
        mfaRequired: false,
        user: data['user'] as Map<String, dynamic>?,
      );
    } on DioException catch (e) {
      throw _messageFrom(e);
    }
  }

  /// Extracts the backend's error message, falling back to a generic one.
  String _messageFrom(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['message'] != null) {
      final msg = data['message'];
      if (msg is List && msg.isNotEmpty) return msg.first.toString();
      return msg.toString();
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'Cannot reach server. Check your connection.';
    }
    return 'Something went wrong. Please try again.';
  }
}
