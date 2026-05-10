class AppException implements Exception {
  final String message;
  final String? code;

  AppException({required this.message, this.code});

  @override
  String toString() => message;
}

class AuthException extends AppException {
  AuthException({required String message, String? code})
      : super(message: message, code: code);
}

class VotingException extends AppException {
  VotingException({required String message, String? code})
      : super(message: message, code: code);
}

class NetworkException extends AppException {
  NetworkException({required String message, String? code})
      : super(message: message, code: code);
}

class ValidationException extends AppException {
  ValidationException({required String message, String? code})
      : super(message: message, code: code);
}
