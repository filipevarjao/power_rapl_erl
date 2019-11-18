-module(rapl_nif).
-export([read_rapl/0]).
-on_load(init/0).

init() ->
  ok = erlang:load_nif("./rapl_erl", 0).

read_rapl() ->
  exit(nif_library_not_loaded).