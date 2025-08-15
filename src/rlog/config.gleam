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
  WithColors
  NoColors
}

pub fn is_colored(color: ColorSwitch) -> Bool {
  case color {
    NoColors -> False
    WithColors -> True
  }
}

pub fn color_enabled(b: Bool) -> ColorSwitch {
  case b {
    True -> WithColors
    False -> NoColors
  }
}

pub type Config {
  Config(
    level: level.LogLevel,
    timestamp: Option(LogTimestamp),
    output: ColorSwitch,
    filter_default_action: filter.Action,
    filters: List(filter.Filters),
  )
}

/// Default config without timestamps
pub fn default_no_ts() -> Config {
  Config(
    level: level.Info,
    timestamp: None,
    output: WithColors,
    filter_default_action: filter.Log,
    filters: filter.default_filters(),
  )
}

/// Default config with Local timestamps
pub fn default_with_ts() -> Config {
  Config(
    level: level.Info,
    timestamp: Some(Local),
    output: WithColors,
    filter_default_action: filter.Log,
    filters: filter.default_filters(),
  )
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
  Config(..cfg, output: WithColors)
}

pub fn uncolored(cfg: Config) -> Config {
  Config(..cfg, output: NoColors)
}

pub fn filters(cfg: Config, filters: List(filter.Filters)) -> Config {
  Config(..cfg, filters: filters)
}
