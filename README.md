# Cbuf

A [circular buffer](https://en.wikipedia.org/wiki/Circular_buffer) based on Erlang's `array` module.

## Installation

```elixir
def deps do
  [
    {:cbuf, "~> 0.2"}
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
Estimated total run time: 2.33 min


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
size medium          35.80 M      0.0279 μs    ±21.10%      0.0260 μs      0.0460 μs
size small           35.64 M      0.0281 μs    ±16.14%      0.0270 μs      0.0460 μs
size large           35.56 M      0.0281 μs    ±16.71%      0.0270 μs      0.0460 μs
size xlarge          35.51 M      0.0282 μs    ±18.05%      0.0270 μs      0.0490 μs
peek medium          17.85 M      0.0560 μs    ±13.19%      0.0540 μs      0.0830 μs
peek small           17.80 M      0.0562 μs    ±12.87%      0.0540 μs      0.0840 μs
peek xlarge          17.69 M      0.0565 μs    ±12.57%      0.0550 μs      0.0830 μs
peek large           17.16 M      0.0583 μs    ±51.86%      0.0600 μs       0.140 μs
new small             8.49 M       0.118 μs   ±230.29%       0.110 μs        0.28 μs
new medium            7.25 M       0.138 μs   ±133.57%       0.130 μs        0.32 μs
new large             6.35 M       0.157 μs   ±126.51%       0.150 μs        0.35 μs
new xlarge            5.66 M       0.177 μs   ±112.80%       0.160 μs        0.39 μs
insert small          5.03 M       0.199 μs    ±97.13%       0.190 μs        0.38 μs
insert medium         2.92 M        0.34 μs  ±1379.93%        0.30 μs        0.70 μs
insert large          2.22 M        0.45 μs   ±724.82%        0.40 μs        1.30 μs
insert xlarge         1.79 M        0.56 μs   ±630.94%        0.50 μs        1.40 μs
to_list small         1.01 M        0.99 μs   ±244.44%        0.90 μs           2 μs
to_list medium      0.0977 M       10.23 μs   ±236.64%          10 μs          20 μs
to_list large      0.00859 M      116.38 μs    ±12.80%         111 μs         170 μs
to_list xlarge     0.00066 M     1506.46 μs    ±12.64%        1455 μs     2091.66 μs

Comparison:
size medium          35.80 M
size small           35.64 M - 1.00x slower
size large           35.56 M - 1.01x slower
size xlarge          35.51 M - 1.01x slower
peek medium          17.85 M - 2.01x slower
peek small           17.80 M - 2.01x slower
peek xlarge          17.69 M - 2.02x slower
peek large           17.16 M - 2.09x slower
new small             8.49 M - 4.22x slower
new medium            7.25 M - 4.94x slower
new large             6.35 M - 5.63x slower
new xlarge            5.66 M - 6.33x slower
insert small          5.03 M - 7.11x slower
insert medium         2.92 M - 12.27x slower
insert large          2.22 M - 16.13x slower
insert xlarge         1.79 M - 20.06x slower
to_list small         1.01 M - 35.38x slower
to_list medium      0.0977 M - 366.40x slower
to_list large      0.00859 M - 4166.50x slower
to_list xlarge     0.00066 M - 53933.24x slower
```
