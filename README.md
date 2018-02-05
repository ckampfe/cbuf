# Cbuf

A [circular buffer](https://en.wikipedia.org/wiki/Circular_buffer) based on Erlang's `array` module.

## Installation

```elixir
def deps do
  [
    {:cbuf, "~> 0.3"}
  ]
end
```

See the docs at [https://hexdocs.pm/cbuf](https://hexdocs.pm/cbuf) for usage information.

## Benchmarks

```
clark$> mix run bench.exs
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.6.1
Erlang 20.2.2
Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
parallel: 1
inputs: none specified
Estimated total run time: 3.73 min


Benchmarking count large...
Benchmarking count medium...
Benchmarking count small...
Benchmarking count xlarge...
Benchmarking delete large...
Benchmarking delete medium...
Benchmarking delete small...
Benchmarking delete xlarge...
Benchmarking insert large...
Benchmarking insert medium...
Benchmarking insert small...
Benchmarking insert xlarge...
Benchmarking new large...
Benchmarking new medium...
Benchmarking new small...
Benchmarking new xlarge...
Benchmarking peek large...
Benchmarking peek medium...
Benchmarking peek small...
Benchmarking peek xlarge...
Benchmarking pop large...
Benchmarking pop medium...
Benchmarking pop small...
Benchmarking pop xlarge...
Benchmarking size large...
Benchmarking size medium...
Benchmarking size small...
Benchmarking size xlarge...
Benchmarking to_list large...
Benchmarking to_list medium...
Benchmarking to_list small...
Benchmarking to_list xlarge...

Name                     ips        average  deviation         median         99th %
size small           35.96 M      0.0278 μs    ±19.55%      0.0270 μs      0.0490 μs
size xlarge          35.69 M      0.0280 μs    ±21.38%      0.0260 μs      0.0550 μs
size large           35.50 M      0.0282 μs    ±20.39%      0.0260 μs      0.0550 μs
size medium          35.44 M      0.0282 μs    ±49.85%      0.0260 μs      0.0550 μs
count large          18.33 M      0.0546 μs    ±14.28%      0.0530 μs      0.0870 μs
count medium         18.09 M      0.0553 μs    ±18.69%      0.0530 μs       0.102 μs
count small          17.94 M      0.0558 μs    ±18.93%      0.0520 μs       0.109 μs
count xlarge         17.87 M      0.0560 μs    ±18.05%      0.0530 μs       0.107 μs
peek large           17.26 M      0.0580 μs    ±13.58%      0.0560 μs      0.0900 μs
peek medium          17.20 M      0.0582 μs    ±16.12%      0.0560 μs       0.114 μs
peek small           16.90 M      0.0592 μs    ±24.04%      0.0560 μs       0.115 μs
peek xlarge          16.82 M      0.0595 μs    ±16.12%      0.0560 μs       0.105 μs
new small             9.28 M       0.108 μs   ±264.78%       0.100 μs        0.27 μs
new medium            7.84 M       0.128 μs   ±262.63%       0.120 μs        0.30 μs
new large             6.87 M       0.146 μs   ±134.53%       0.140 μs        0.33 μs
new xlarge            6.14 M       0.163 μs   ±113.47%       0.150 μs        0.34 μs
delete small          5.10 M       0.196 μs    ±44.97%       0.180 μs        0.46 μs
insert small          5.07 M       0.197 μs    ±92.47%       0.190 μs        0.39 μs
pop small             3.26 M        0.31 μs  ±2120.34%        0.30 μs        0.60 μs
insert medium         2.89 M        0.35 μs  ±1651.24%        0.30 μs        0.70 μs
delete medium         2.84 M        0.35 μs  ±1494.52%        0.30 μs        0.70 μs
pop medium            2.41 M        0.42 μs  ±1021.78%        0.40 μs        0.90 μs
insert large          2.19 M        0.46 μs   ±813.01%        0.40 μs        0.90 μs
delete large          2.12 M        0.47 μs  ±1086.66%        0.40 μs        1.20 μs
pop large             1.86 M        0.54 μs   ±724.16%        0.50 μs        1.40 μs
insert xlarge         1.77 M        0.56 μs   ±706.75%        0.50 μs        1.40 μs
delete xlarge         1.73 M        0.58 μs   ±826.02%        0.50 μs        1.40 μs
pop xlarge            1.56 M        0.64 μs   ±537.68%        0.60 μs        1.60 μs
to_list small         1.03 M        0.97 μs  ±6093.68%           1 μs           2 μs
to_list medium       0.123 M        8.12 μs   ±463.24%           7 μs          18 μs
to_list large       0.0105 M       95.39 μs    ±19.77%          90 μs         174 μs
to_list xlarge     0.00076 M     1313.43 μs    ±18.87%        1243 μs     2242.16 μs

Comparison:
size small           35.96 M
size xlarge          35.69 M - 1.01x slower
size large           35.50 M - 1.01x slower
size medium          35.44 M - 1.01x slower
count large          18.33 M - 1.96x slower
count medium         18.09 M - 1.99x slower
count small          17.94 M - 2.00x slower
count xlarge         17.87 M - 2.01x slower
peek large           17.26 M - 2.08x slower
peek medium          17.20 M - 2.09x slower
peek small           16.90 M - 2.13x slower
peek xlarge          16.82 M - 2.14x slower
new small             9.28 M - 3.87x slower
new medium            7.84 M - 4.58x slower
new large             6.87 M - 5.24x slower
new xlarge            6.14 M - 5.85x slower
delete small          5.10 M - 7.05x slower
insert small          5.07 M - 7.09x slower
pop small             3.26 M - 11.05x slower
insert medium         2.89 M - 12.47x slower
delete medium         2.84 M - 12.67x slower
pop medium            2.41 M - 14.93x slower
insert large          2.19 M - 16.42x slower
delete large          2.12 M - 17.00x slower
pop large             1.86 M - 19.30x slower
insert xlarge         1.77 M - 20.27x slower
delete xlarge         1.73 M - 20.80x slower
pop xlarge            1.56 M - 23.07x slower
to_list small         1.03 M - 34.87x slower
to_list medium       0.123 M - 291.83x slower
to_list large       0.0105 M - 3430.22x slower
to_list xlarge     0.00076 M - 47232.59x slower
```
