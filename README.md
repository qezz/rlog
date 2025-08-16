# rlog - reasonable logger (for Gleam)

[![Package Version](https://img.shields.io/hexpm/v/reasonable_logger)](https://hex.pm/packages/reasonable_logger)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/reasonable_logger/)

Rlog is a thin wrapper for Erlang's default logger, with some
configuration options exposed for the user.

The implementation is heavily inspired by [lpil/logging](https://github.com/lpil/logging).

> [!CAUTION]
> **This library interface is unstable, and will change over time.**

```sh
gleam add rlog@0
```

```gleam
import gleam/erlang/process
import rlog
import rlog/config
import rlog/level

pub fn main() -> Nil {
  let cfg =
    config.default_config()
    |> config.log_level(level.Info)
    |> config.with_ts(config.Utc)
    |> config.colored()

  rlog.configure(cfg)
  rlog.info("Hello world")

  // Because the Erlang's logger is async, the logger might not flush
  // in time before the app has finished.
  //
  // It is not required in a normal scenario for long running tasks.
  process.sleep(100)
}
```

Further documentation can be found at <https://hexdocs.pm/rlog>.

## Compared to `lpil/logging`

The `logging` package provides simple interface for Erlang's logger.

`rlog` builds on top of `logging` and provides additional configuration
options for the logger.

With the following config, the output will be similar to the `logging`
package:

```gleam
import rlog
import rlog/config

pub fn main() -> Nil {
  config.default_no_ts()
  |> rlog.configure()

  rlog.info("no timestamps here")
}

// Sample output:
//
// INFO no timestamps here
```

For timestamps in local time:

```gleam
config.default_with_local_ts()
|> rlog.configure()

rlog.info("in local time")

// Sample output:
//
// 2025-08-15T12:34:56 INFO in local time
```

For timestamps in UTC:

```gleam
config.default_with_utc_ts()
|> rlog.configure()

rlog.info("always in UTC")

// Sample output
//
// 2025-08-15T12:34:56Z INFO always in UTC
```


## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam dev   # Run dev "tests"
```
