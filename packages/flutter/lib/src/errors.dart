class EchoButlerError implements Exception {
  final String message;
  const EchoButlerError(this.message);

  @override
  String toString() => 'EchoButlerError: $message';
}

class EchoButlerAuthError extends EchoButlerError {
  const EchoButlerAuthError([super.message = 'Invalid or expired API key']);
}

class EchoButlerNetworkError extends EchoButlerError {
  const EchoButlerNetworkError([super.message = 'Network request failed']);
}

class EchoButlerRateLimitError extends EchoButlerError {
  const EchoButlerRateLimitError([super.message = 'Rate limit exceeded']);
}
