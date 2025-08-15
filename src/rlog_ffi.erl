-module(rlog_ffi).

-export([configure/1, format/2]).

configure({internal_config,
           Level,
           Timestamp,
           ColoredOutput,
           FilterDefaultAction,
           FiltersRaw}) ->
    Filters = domain_filters_from_raw(FiltersRaw),
    logger:update_primary_config(#{level => Level,
                                   filter_default => FilterDefaultAction,
                                   filters => Filters,
                                   metadata => #{}}),
    logger:update_handler_config(default,
                                 #{formatter =>
                                       {rlog_ffi,
                                        #{colored => ColoredOutput, timestamp => Timestamp}}}),
    nil.

domain_filters_from_raw(Filters) ->
    lists:map(fun filter_from_raw/1, Filters).

filter_from_raw({domain, Action, Type, Items}) ->
    TransformedItems = lists:map(fun atom_from_gleam_enum/1, Items),
    {domain, {fun logger_filters:domain/2, {Action, Type, TransformedItems}}}.

atom_from_gleam_enum({predefined_atom, Atom}) ->
    Atom;
atom_from_gleam_enum({str, Binary}) ->
    binary_to_atom(Binary, utf8).

format(#{level := Level,
         msg := Msg,
         meta := _Meta},
       Config) ->
    [format_timestamp(Config), format_level(Level, Config), format_msg(Msg), $\n].

format_level(Level, #{colored := Colored}) ->
    case Colored of
        true ->
            format_level_colored(Level);
        false ->
            format_level_uncolored(Level)
    end.

format_timestamp(#{timestamp := Ts}) ->
    case Ts of
        {some, utc} ->
            calendar:system_time_to_rfc3339(
                erlang:system_time(second), [{unit, second}, {offset, "Z"}])
            ++ " ";
        {some, utc_with_timezone} ->
            calendar:system_time_to_rfc3339(
                erlang:system_time(second), [{unit, second}])
            ++ " ";
        {some, local} ->
            %% Well, apparently there's no clear way to get the local time, so here wo go
            {{Y, M, D}, {H, Min, S}} = calendar:local_time(),
            io_lib:format("~4..0w-~2..0w-~2..0wT~2..0w:~2..0w:~2..0w", [Y, M, D, H, Min, S]) ++ " ";
        _ ->
            ""
    end.

format_level_uncolored(Level) ->
    case Level of
        emergency ->
            "EMRG";
        alert ->
            "ALRT";
        critical ->
            "CRIT";
        error ->
            "EROR";
        warning ->
            "WARN";
        notice ->
            "NTCE";
        info ->
            "INFO";
        debug ->
            "DEBG"
    end.

format_level_colored(Level) ->
    case Level of
        emergency ->
            "\x1b[1;41mEMRG\x1b[0m";
        alert ->
            "\x1b[1;41mALRT\x1b[0m";
        critical ->
            "\x1b[1;41mCRIT\x1b[0m";
        error ->
            "\x1b[1;31mEROR\x1b[0m";
        warning ->
            "\x1b[1;33mWARN\x1b[0m";
        notice ->
            "\x1b[1;32mNTCE\x1b[0m";
        info ->
            "\x1b[1;34mINFO\x1b[0m";
        debug ->
            "\x1b[1;36mDEBG\x1b[0m"
    end.

format_msg(Report0) ->
    case Report0 of
        {string, Msg} ->
            [$\s, Msg];
        {report, Report1} when is_map(Report1) ->
            format_kv(maps:to_list(Report1));
        {report, Report1} when is_list(Report1) ->
            format_kv(Report1);
        _ ->
            [$\s, gleam@string:inspect(Report0)]
    end.

format_kv(Pairs) ->
    case Pairs of
        [] ->
            [];
        [{K, V} | Rest] when is_atom(K) ->
            [$\s, erlang:atom_to_binary(K), $=, gleam@string:inspect(V) | format_kv(Rest)];
        [{K, V} | Rest] ->
            [$\s, gleam@string:inspect(K), $=, gleam@string:inspect(V) | format_kv(Rest)];
        Other ->
            gleam@string:inspect(Other)
    end.
