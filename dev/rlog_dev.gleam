import gleam/erlang/process
import rlog
import rlog/config
import rlog/config/level

pub fn main() -> Nil {
  let cfg =
    config.default_with_ts()
    |> config.log_level(level.Info)
    |> config.with_ts(config.Utc)
    |> config.colored()

  rlog.configure(cfg)

  echo rlog.get_config()

  rlog.critical("Hello world")
  rlog.alert("Hello world")
  rlog.error("Hello world")
  rlog.emergency("Hello world")
  rlog.notice("Hello world")
  rlog.info("Hello world")
  rlog.debug("Hello world")

  rlog.set_level(level.Debug)
  rlog.debug("Hello from Debug world")

  // Because the Erlang's logger is async, the logger might not flush
  // in time before the app has finished.
  //
  // It is not required in normal scenario for long running tasks.
  process.sleep(100)
}
