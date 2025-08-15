import gleam/dynamic.{type Dynamic}
import rlog/config
import rlog/config/level.{
  type LogLevel, Alert, Critical, Debug, Emergency, Error, Info, Notice, Warning,
}
import rlog/internal

/// This type ensures that we don't return weird stuff from the Erlang functions.
/// If we try to, it will be a compilation error.
type PrivateType

/// Helper type, to pass Erlang-style atom `{level, ...}` to the logger functions.
type Key {
  Level
}

@external(erlang, "rlog_ffi", "configure")
fn erlang_logger_configure(cfg: internal.InternalConfig) -> Nil

@external(erlang, "logger", "log")
fn erlang_log(level: LogLevel, message: String) -> PrivateType

@external(erlang, "logger", "set_primary_config")
fn set_primary_config_level(key: Key, level: LogLevel) -> PrivateType

@external(erlang, "logger", "get_config")
fn erlang_get_config() -> Dynamic

pub fn log(level: LogLevel, message: String) -> Nil {
  erlang_log(level, message)
  Nil
}

pub fn emergency(message: String) -> Nil {
  log(Emergency, message)
}

pub fn alert(message: String) -> Nil {
  log(Alert, message)
}

pub fn critical(message: String) -> Nil {
  log(Critical, message)
}

pub fn error(message: String) -> Nil {
  log(Error, message)
}

pub fn warning(message: String) -> Nil {
  log(Warning, message)
}

pub fn notice(message: String) -> Nil {
  log(Notice, message)
}

pub fn info(message: String) -> Nil {
  log(Info, message)
}

pub fn debug(message: String) -> Nil {
  log(Debug, message)
}

pub fn configure(cfg: config.Config) -> Nil {
  let icfg = internal.config_from_config(cfg)
  erlang_logger_configure(icfg)
}

/// Change/update logging level
pub fn set_level(level: LogLevel) -> Nil {
  set_primary_config_level(Level, level)
  Nil
}

pub fn get_config() -> Dynamic {
  erlang_get_config()
}
