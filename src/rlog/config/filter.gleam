/// Mapped from `filter_default` option.
///
/// https://www.erlang.org/doc/apps/kernel/logger_chapter.html
///
/// filter_default = log | stop - Specifies what happens to a log event if all
/// filters return ignore, or if no filters exist.
///
/// https://www.erlang.org/doc/apps/kernel/logger_chapter.html#filters
///
/// The configuration option `filter_default` specifies the behaviour if all
/// filter functions return `ignore`, or if no filters exist. `filter_default`
/// is by default set to `log`, meaning that if all existing filters ignore
/// a log event, Logger forwards the event to the handler callback.
/// If `filter_default` is set to `stop`, Logger discards such events.
pub type Action {
  Log
  Stop
}

pub type Compare {
  Sub
  Super
  Equal
  NotEqual
  Undefined
}

// TODO: Maybe turn into a fixed string so it's more convenient to use?
pub type Atom {
  Otp
  Sasl
  SupervisorReport
}

pub type MatchDomain {
  // Predefined atom will be used as-is, as coerced by Gleam compiler.
  PredefinedAtom(Atom)
  // Str will be converted into an atom, e.g.
  // "supervisor_report" -> supervisor_report
  Str(String)
}

pub type Filters {
  Domain(action: Action, compare: Compare, match: List(MatchDomain))
}

pub fn default_filters() {
  [
    Domain(action: Stop, compare: Sub, match: [
      PredefinedAtom(Otp),
      PredefinedAtom(Sasl),
    ]),
    Domain(action: Stop, compare: Sub, match: [
      PredefinedAtom(SupervisorReport),
    ]),
  ]
}
