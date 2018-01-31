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

To run the benchmarks:

```
$ mix run bench.exs
```

```
clark$> mix run bench.exs
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.6.0
Erlang 20.2.2
Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
parallel: 1
inputs: none specified
Estimated total run time: 2.80 min


Benchmarking count large...
Benchmarking count medium...
Benchmarking count small...
Benchmarking count xlarge...
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
Benchmarking size large...
Benchmarking size medium...
Benchmarking size small...
Benchmarking size xlarge...
Benchmarking to_list large...
Benchmarking to_list medium...
Benchmarking to_list small...
Benchmarking to_list xlarge...

Name                     ips        average  deviation         median         99th %
size small           37.86 M      0.0264 μs    ±16.42%      0.0250 μs      0.0460 μs
size xlarge          37.26 M      0.0268 μs    ±18.20%      0.0250 μs      0.0500 μs
size large           37.21 M      0.0269 μs    ±17.63%      0.0260 μs      0.0480 μs
size medium          37.16 M      0.0269 μs    ±18.61%      0.0260 μs      0.0520 μs
count medium         19.16 M      0.0522 μs    ±15.73%      0.0500 μs      0.0910 μs
count small          19.04 M      0.0525 μs    ±15.41%      0.0500 μs      0.0900 μs
count large          18.69 M      0.0535 μs    ±19.69%      0.0500 μs      0.0930 μs
count xlarge         18.52 M      0.0540 μs    ±42.24%      0.0500 μs       0.110 μs
peek large           17.08 M      0.0586 μs    ±15.42%      0.0550 μs      0.0980 μs
peek medium          17.04 M      0.0587 μs    ±15.43%      0.0560 μs      0.0990 μs
peek small           16.64 M      0.0601 μs    ±41.77%      0.0600 μs       0.130 μs
peek xlarge          16.63 M      0.0602 μs    ±43.48%      0.0600 μs       0.130 μs
new small             8.59 M       0.117 μs   ±284.71%       0.110 μs        0.27 μs
new large             6.48 M       0.154 μs   ±125.67%       0.140 μs        0.33 μs
new medium            5.85 M       0.171 μs  ±2990.97%       0.100 μs        0.30 μs
new xlarge            5.82 M       0.172 μs   ±139.40%       0.160 μs        0.36 μs
insert small          4.17 M        0.24 μs  ±2849.26%        0.20 μs        0.40 μs
insert medium         2.92 M        0.34 μs  ±1592.38%        0.30 μs        0.70 μs
insert large          2.22 M        0.45 μs   ±754.39%        0.40 μs        1.20 μs
insert xlarge         1.79 M        0.56 μs   ±642.11%        0.50 μs        1.40 μs
to_list small         1.37 M        0.73 μs   ±476.96%        0.70 μs        1.60 μs
to_list medium       0.127 M        7.88 μs   ±469.30%           7 μs          16 μs
to_list large       0.0110 M       91.04 μs    ±15.31%          86 μs         148 μs
to_list xlarge     0.00081 M     1232.97 μs    ±16.85%        1181 μs     2034.35 μs

Comparison:
size small           37.86 M
size xlarge          37.26 M - 1.02x slower
size large           37.21 M - 1.02x slower
size medium          37.16 M - 1.02x slower
count medium         19.16 M - 1.98x slower
count small          19.04 M - 1.99x slower
count large          18.69 M - 2.03x slower
count xlarge         18.52 M - 2.04x slower
peek large           17.08 M - 2.22x slower
peek medium          17.04 M - 2.22x slower
peek small           16.64 M - 2.27x slower
peek xlarge          16.63 M - 2.28x slower
new small             8.59 M - 4.41x slower
new large             6.48 M - 5.84x slower
new medium            5.85 M - 6.47x slower
new xlarge            5.82 M - 6.51x slower
insert small          4.17 M - 9.08x slower
insert medium         2.92 M - 12.96x slower
insert large          2.22 M - 17.08x slower
insert xlarge         1.79 M - 21.14x slower
to_list small         1.37 M - 27.65x slower
to_list medium       0.127 M - 298.47x slower
to_list large       0.0110 M - 3446.79x slower
to_list xlarge     0.00081 M - 46678.47x slower
```
