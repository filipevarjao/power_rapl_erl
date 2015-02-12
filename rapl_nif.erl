-module(rapl_nif).
-export([start_rapl/0, read_rapl/0]).
-on_load(init/0).

init() ->
  ok = erlang:load_nif("./rapl_erl", 0).

start_rapl() ->
  exit(nif_library_not_loaded).
read_rapl() ->
  exit(nif_library_not_loaded).

% gcc -fPIC -shared -o rapl_erl.so rapl_erl.c -I /usr/local/lib/erlang/usr/include/