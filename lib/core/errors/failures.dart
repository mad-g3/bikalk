// Domain failure types
// Implements Exception so repositories can throw Failure instances
// and cubits can catch them with `on Failure`.
abstract class Failure implements Exception {
  const Failure(this.message);

  final String message;

  @override
  String toString() => 'Failure($runtimeType): $message';
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'A server error occurred.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'An authentication error occurred.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Permission denied.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed.']);
}
