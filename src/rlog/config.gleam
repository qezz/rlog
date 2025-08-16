// import rlog
import gleam/option.{type Option, None, Some}
import rlog/config/filter
import rlog/config/level

pub type LogTimestamp {
  Utc
  Local
  UtcWithTimezone
}

pub type ColorSwitch {
  Colored
  Plain
}

pub fn is_colored(color: ColorSwitch) -> Bool {
  case color {
    Plain -> False
    Colored -> True
  }
}

pub fn color_enabled(b: Bool) -> ColorSwitch {
  case b {
    True -> Colored
    False -> Plain
  }
}

pub type Config {
  Config(
    level: level.LogLevel,
    timestamp: Option(LogTimestamp),
    color: ColorSwitch,
    filter_default_action: filter.Action,
    filters: List(filter.Filters),
  )
}

/// Default config without timestamps
pub fn default_no_ts() -> Config {
  Config(
    level: level.Info,
    timestamp: None,
    color: Colored,
    filter_default_action: filter.Log,
    filters: filter.default_filters(),
  )
}

/// Default config with Local timestamps
pub fn default_with_local_ts() -> Config {
  default_no_ts()
  |> with_ts(Local)
}

/// Default config with UTC timestamps
pub fn default_with_utc_ts() -> Config {
  default_no_ts()
  |> with_ts(Utc)
}

pub fn log_level(cfg: Config, level: level.LogLevel) -> Config {
  Config(..cfg, level: level)
}

pub fn with_ts(cfg: Config, ts: LogTimestamp) -> Config {
  Config(..cfg, timestamp: Some(ts))
}

pub fn without_ts(cfg: Config) -> Config {
  Config(..cfg, timestamp: None)
}

pub fn colored(cfg: Config) -> Config {
  Config(..cfg, color: Colored)
}

pub fn plain(cfg: Config) -> Config {
  Config(..cfg, color: Plain)
}

pub fn filters(cfg: Config, filters: List(filter.Filters)) -> Config {
  Config(..cfg, filters: filters)
}
