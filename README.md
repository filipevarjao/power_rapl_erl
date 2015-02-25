### Energy Profiling for Erlang and Elixir

================================

`power_rapl_erl` is a tool to provide the profiling energy comsumption for `Erlang` and `Elixir`for the whole CPU. power_rapl_erl use Inte's RAPL (Running Average Power Limit) interface to indicate the amount of energy comsumed.


### How to build `power_rapl_erl`
 
 To build `power_rapl_erl` you just need compile the file, indicating where is our erlang/usr/include path:
 
 
       $  gcc -fPIC -shared -o rapl_erl.so rapl_erl.c -I /*/erlang/usr/include/
   


 Remeber to change the permission to access the  `/dev/cpu/*/msr` file. Compile the `rapl_nif` and `rapl_erl` files too.


### How to use `power_rapl_erl`

 
 Run in Erlang:
 
       1> rapl_erl:start_energy_profiling(fibonacci, fib, [4]).
        Result: 3
           MODULE      |    FUNCTION   |    ENERGY BEFORE      |     ENERGY AFTER      |     ENERGY CONSUMED
        fibonacci      |         fib   |     50267.433258      |     50267.451721      |            0.018463
   


 Run in Elixir:
 
 
       iex(1)> :rapl_erl.start_energy_profiling(Fibonacci, :fib, [4])
        Result: 5
            MODULE      |    FUNCTION   |    ENERGY BEFORE      |     ENERGY AFTER      |     ENERGY CONSUMED
        Elixir.Fib      |         fib   |     54245.303635      |     54245.310242      |            0.006607  
   

