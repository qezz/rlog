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

For local timestamps (recommended):

```gleam
config.default_with_local_ts()
|> rlog.configure()

rlog.info("in local time")

// Sample output:
//
// 2025-08-15T12:34:56 INFO in local time
```

For other options, see docs and public API in [config.gleam](src/rlog/config.gleam)

Both `rlog` and `logging` libraries use Erlang's logger under the hood.
If you use `logging` in your app, you can use `rlog` only for configuration
purposes:

```gleam
import logging
import rlog
import rlog/config

pub fn main() -> Nil {
  config.default_with_local_ts()
  |> rlog.configure()

  logging.log(logging.Info, "Hello from logging")
}
```

Don't forget to remove `logging.configure()`.

See [example with `logging`](examples/with_other_libs/src/app.gleam) for more details.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam dev   # Run dev "tests"
```
