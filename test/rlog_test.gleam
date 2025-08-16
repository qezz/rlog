import gleeunit
import rlog
import rlog/config
import rlog/config/filter
import rlog/config/level

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn log_test() {
  rlog.configure(config.default_with_local_ts())
  rlog.log(level.Info, "simple :: hello info")
  rlog.warning("simple :: hello warning")
}

pub fn log_config_test() {
  let cfg =
    config.default_with_local_ts()
    |> config.log_level(level.Info)
    |> config.without_ts()
    |> config.colored()

  rlog.configure(cfg)
  rlog.info("no_timestamp :: test config")
}

pub fn log_config_utc_test() {
  let cfg =
    config.default_with_local_ts()
    |> config.with_ts(config.Utc)
    |> config.colored()

  rlog.configure(cfg)
  rlog.info("utc :: test (should show UTC time)")
}

pub fn log_config_local_test() {
  let cfg =
    config.default_with_local_ts()
    |> config.with_ts(config.Local)
    |> config.colored()

  rlog.configure(cfg)
  rlog.info("local_ts :: test (should show local time)")
}

pub fn log_config_no_color_test() {
  let cfg =
    config.default_with_local_ts()
    |> config.plain()

  rlog.configure(cfg)
  rlog.info("no_color:: test (should be without color)")
}

pub fn log_set_level_test() {
  rlog.configure(config.default_with_local_ts())
  rlog.info(
    "set_level :: info (should be shown, but the next 'debug' line should not)",
  )
  rlog.debug("set_level :: debug")
  rlog.set_level(level.Debug)
  rlog.info(
    "set_level :: info (the next debug line should now be shown after the set_level(Debug)",
  )
  rlog.debug("set_level :: debug")
}

pub fn as_logging_test() {
  config.default_with_local_ts()
  |> config.without_ts()
  |> rlog.configure()

  rlog.info("as_logging :: no timestamps here")
}

pub fn filters_test() {
  config.default_with_local_ts()
  |> config.filters([
    filter.Domain(action: filter.Stop, compare: filter.Sub, match: [
      filter.PredefinedAtom(filter.Otp),
      filter.PredefinedAtom(filter.Sasl),
    ]),
    filter.Domain(action: filter.Stop, compare: filter.Sub, match: [
      filter.Str("supervisor_report"),
    ]),
  ])
}
