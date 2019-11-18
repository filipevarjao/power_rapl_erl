-module(rapl_erl).
-export([start_energy_profiling/3, start/3, check/6, bin_to_num/1, reload/0,
  print_h/0, print_r/5]).

-import(rapl_nif, [read_rapl/0]).

start_energy_profiling(M, F, A) ->
  spawn(fun() -> start(M, F, A) end).

start(M, F, A) ->
  Eb = list_to_binary(read_rapl()),
  {_, Result} = timer:tc(M, F, A),
  Ea = list_to_binary(read_rapl()),

  check(M, F, A, Result, Eb, Ea).

check(M, F, A, Result, Eb, Ea) ->
  case Eb =:= Ea of
    false ->
      R = bin_to_num(Ea) - bin_to_num(Eb),
      Er = io_lib:format("~.6f",[R]),
      io:format("Result: ~p~n", [Result]),
      print_h(),
      print_r(M, F, Eb, Ea, Er);
    true ->
      reload(),
      start_energy_profiling(M, F, A)
  end.

reload() ->
  code:purge(?MODULE),
  compile:file(?MODULE),
  code:load_file(?MODULE).

print_h() ->
  H = ["MODULE", "FUNCTION", "ENERGY BEFORE", "ENERGY AFTER", "ENERGY CONSUMED"],
  Format = "~10s\t|~12s\t|~17s\t|~17s\t|~20s\r\n",
  io:format(Format, H).

print_r(_M, _F, _Eb, _Ea, _Er) ->
  Format = "~10s\t|~12s\t|~17s\t|~17s\t|~20s\r\n",
  io:format(Format, [_M, _F, _Eb, _Ea, _Er]).

bin_to_num(Bin) ->
  N = binary_to_list(Bin),
  case string:to_float(N) of
    {error,no_float} -> list_to_integer(N);
    {F,_Rest} -> F
  end.