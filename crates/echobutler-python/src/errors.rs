use echobutler_core::EchoButlerError;
use pyo3::exceptions::PyException;
use pyo3::{create_exception, PyErr};

// Base exception for everything raised by the SDK, mirroring the error
// hierarchy already exposed by the JS (`EchoButlerError`/`AuthError`/...)
// and Flutter (`EchoButlerError`/`EchoButlerAuthError`/...) packages.
create_exception!(_echobutler, EchoButlerException, PyException);
create_exception!(_echobutler, AuthError, EchoButlerException);
create_exception!(_echobutler, NetworkError, EchoButlerException);
create_exception!(_echobutler, RateLimitError, EchoButlerException);
create_exception!(_echobutler, NotFoundError, EchoButlerException);
create_exception!(_echobutler, ConfigError, EchoButlerException);

/// Map a Rust-side `EchoButlerError` onto the matching Python exception type.
pub fn to_py_err(err: EchoButlerError) -> PyErr {
    match err {
        EchoButlerError::Auth(msg) => AuthError::new_err(msg),
        EchoButlerError::AuthExpired => AuthError::new_err("Authentication token expired"),
        EchoButlerError::RateLimit { retry_after_secs } => RateLimitError::new_err(format!(
            "Rate limit exceeded — retry after {retry_after_secs}s"
        )),
        EchoButlerError::Network(e) => NetworkError::new_err(e.to_string()),
        EchoButlerError::NotFound(msg) => NotFoundError::new_err(msg),
        EchoButlerError::Config(msg) => ConfigError::new_err(msg),
        EchoButlerError::Http {
            status: 404,
            message,
        } => NotFoundError::new_err(message),
        other => EchoButlerException::new_err(other.to_string()),
    }
}
