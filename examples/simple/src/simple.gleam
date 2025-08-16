import gleam/erlang/process
import rlog
import rlog/config
import rlog/config/level

pub fn main() -> Nil {
  let cfg =
    config.default_no_ts()
    |> config.log_level(level.Info)
    |> config.with_ts(config.Local)
    |> config.colored()

  rlog.configure(cfg)
  rlog.info("Hello world")

  // Because the Erlang's logger is async, the logger might not flush
  // in time before the app has finished.
  //
  // It is not required in a normal scenario for long running tasks.
  process.sleep(100)
}
