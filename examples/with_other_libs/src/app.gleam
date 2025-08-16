import gleam/erlang/process
import logging
import rlog
import rlog/config
import rlog/config/level

pub fn main() -> Nil {
  config.default_no_ts()
  |> config.log_level(level.Info)
  |> config.with_ts(config.Local)
  |> config.colored()
  |> rlog.configure()

  rlog.info("Hello from rlog")
  rlog.debug("Hello from rlog DEBUG level")
  rlog.log(level.Debug, "Hello from rlog DEBUG level")

  logging.log(logging.Info, "Hello from logging")
  logging.log(logging.Debug, "Hello from logging DEBUG level")

  rlog.warning("Setting log level to DEBUG")

  rlog.set_level(level.Debug)

  rlog.info("Hello from rlog")
  rlog.debug("Hello from rlog DEBUG level")
  rlog.log(level.Debug, "Hello from rlog DEBUG level")

  logging.log(logging.Info, "Hello from logging")
  logging.log(logging.Debug, "Hello from logging DEBUG level")

  // Because the Erlang's logger is async, the logger might not flush
  // in time before the app has finished.
  //
  // It is not required in a normal scenario for long running tasks.
  process.sleep(100)
}
