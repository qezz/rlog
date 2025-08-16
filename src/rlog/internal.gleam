import gleam/option.{type Option}
import rlog/config
import rlog/config/filter
import rlog/config/level

pub type InternalConfig {
  InternalConfig(
    level: level.LogLevel,
    timestamp: Option(config.LogTimestamp),
    colored_output: Bool,
    filter_default_action: filter.Action,
    filters: List(filter.Filters),
  )
}

pub fn config_from_config(cfg: config.Config) -> InternalConfig {
  InternalConfig(
    level: cfg.level,
    timestamp: cfg.timestamp,
    colored_output: config.is_colored(cfg.color),
    filter_default_action: cfg.filter_default_action,
    filters: cfg.filters,
  )
}
