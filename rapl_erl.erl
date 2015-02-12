-module(rapl_erl).
-export([start_energy_profiling/3,
  bin_to_num/1, print_h/0, print_r/5]).


-import(rapl_nif, [start_rapl/0, read_rapl/0]).

start_energy_profiling(M, F, A) ->
  Initial_energy_status = list_to_binary(start_rapl()),
  timer:tc(M, F, A),
  %sleep(1000),
  Final_energy_status = list_to_binary(read_rapl()),
  Eb = bin_to_num(Initial_energy_status),
  Ea = bin_to_num(Final_energy_status),
  R = Ea - Eb,
  Result = io_lib:format("~.6f",[R]),
  print_h(),
  print_r(M, F, lists:flatten(io_lib:format("~p", [Eb])),
    lists:flatten(io_lib:format("~p", [Ea])), Result).

print_h() ->
  H = ["MODULE", "FUNCTION", "ENERGY BEFORE", "ENERGY AFTER", "ENERGY CONSUMED"],
  Format = "~10s\t|~12s\t|~17s\t|~17s\t|~20s\r\n",
  io:format(Format, H).

print_r(_M, _F, _Eb, _Ea, _Result) ->
  Format = "~10s\t|~12s\t|~17s\t|~17s\t|~20s\r\n",
  io:format(Format, [_M, _F, _Eb, _Ea, _Result]).


bin_to_num(Bin) ->
  N = binary_to_list(Bin),
  case string:to_float(N) of
    {error,no_float} -> list_to_integer(N);
    {F,_Rest} -> F
  end.