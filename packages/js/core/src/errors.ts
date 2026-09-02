export class EchoButlerError extends Error {
  constructor(
    message: string,
    public readonly statusCode?: number,
  ) {
    super(message)
    this.name = 'EchoButlerError'
  }
}

export class AuthError extends EchoButlerError {
  constructor(message = 'Authentication failed') {
    super(message, 401)
    this.name = 'AuthError'
  }
}

export class NetworkError extends EchoButlerError {
  constructor(message = 'Network request failed') {
    super(message)
    this.name = 'NetworkError'
  }
}

export class RateLimitError extends EchoButlerError {
  constructor(public readonly retryAfterSeconds: number) {
    super(`Rate limit exceeded. Retry after ${retryAfterSeconds}s`, 429)
    this.name = 'RateLimitError'
  }
}
