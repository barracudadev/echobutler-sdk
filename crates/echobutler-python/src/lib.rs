// pyo3 0.22's `create_exception!` macro and `#[pymethods]` codegen trip two
// lints on code *they* generate, not on anything we wrote: an `unexpected_cfgs`
// warning from an internal `gil-refs` check, and a `useless_conversion` on the
// generated `PyErr -> PyErr` wrapping for async method return types.
#![allow(unexpected_cfgs)]
#![allow(clippy::useless_conversion)]

use pyo3::prelude::*;

mod client;
mod echo_butler;
mod errors;
mod mood;
mod social;
mod stellar;
mod types;

use client::{PyEchoButlerClient, PyStellarNetwork};
use echo_butler::PyEchoButler;
use mood::PyMoodClient;
use social::PySocialClient;
use stellar::PyStellarClient;
use types::*;

/// Native (PyO3) extension module backing the `echobutler` Python package.
/// See `python/echobutler/__init__.py` for the public re-exports.
#[pymodule]
fn _echobutler(py: Python<'_>, m: &Bound<'_, PyModule>) -> PyResult<()> {
    // Core client + convenience entry point
    m.add_class::<PyEchoButlerClient>()?;
    m.add_class::<PyStellarNetwork>()?;
    m.add_class::<PyEchoButler>()?;

    // Sub-clients
    m.add_class::<PyMoodClient>()?;
    m.add_class::<PyStellarClient>()?;
    m.add_class::<PySocialClient>()?;

    // Data types
    m.add_class::<PyMoodEntry>()?;
    m.add_class::<PyMoodStreak>()?;
    m.add_class::<PyMoodSummary>()?;
    m.add_class::<PyAiReflection>()?;
    m.add_class::<PyMoodHistoryPage>()?;
    m.add_class::<PyStellarBalance>()?;
    m.add_class::<PyStellarTransaction>()?;
    m.add_class::<PyUnsignedTransaction>()?;
    m.add_class::<PyTransactionHistoryPage>()?;
    m.add_class::<PyUserProfile>()?;
    m.add_class::<PyLeaderboardEntry>()?;
    m.add_class::<PyGlobalFeedEntry>()?;

    // Exceptions
    m.add(
        "EchoButlerException",
        py.get_type_bound::<errors::EchoButlerException>(),
    )?;
    m.add("AuthError", py.get_type_bound::<errors::AuthError>())?;
    m.add("NetworkError", py.get_type_bound::<errors::NetworkError>())?;
    m.add(
        "RateLimitError",
        py.get_type_bound::<errors::RateLimitError>(),
    )?;
    m.add(
        "NotFoundError",
        py.get_type_bound::<errors::NotFoundError>(),
    )?;
    m.add("ConfigError", py.get_type_bound::<errors::ConfigError>())?;

    m.add("__version__", env!("CARGO_PKG_VERSION"))?;
    Ok(())
}
