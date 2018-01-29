# Cbuf

A [circular buffer](https://en.wikipedia.org/wiki/Circular_buffer) based on Erlang's `array` module.

## Installation

```elixir
def deps do
  [
    {:cbuf, "~> 0.1.0"}
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
size large           34.48 M      0.0290 μs    ±30.93%      0.0260 μs      0.0550 μs
size xlarge          34.12 M      0.0293 μs    ±42.82%      0.0270 μs      0.0550 μs
size small           33.84 M      0.0296 μs    ±45.22%      0.0270 μs      0.0550 μs
size medium          33.74 M      0.0296 μs    ±47.19%      0.0270 μs      0.0550 μs
peek small           17.00 M      0.0588 μs    ±22.32%      0.0550 μs       0.112 μs
peek medium          16.78 M      0.0596 μs    ±24.11%      0.0550 μs       0.111 μs
peek large           16.59 M      0.0603 μs    ±25.43%      0.0550 μs       0.112 μs
peek xlarge          16.47 M      0.0607 μs    ±52.92%      0.0600 μs       0.150 μs
new small             8.35 M       0.120 μs   ±245.21%       0.110 μs        0.30 μs
new medium            7.09 M       0.141 μs   ±138.43%       0.130 μs        0.34 μs
new large             6.17 M       0.162 μs   ±130.64%       0.150 μs        0.37 μs
new xlarge            5.58 M       0.179 μs   ±113.06%       0.160 μs        0.38 μs
insert small          4.35 M        0.23 μs    ±86.82%        0.21 μs        0.44 μs
insert medium         2.63 M        0.38 μs  ±1428.77%        0.30 μs        0.80 μs
insert large          1.97 M        0.51 μs   ±881.49%        0.40 μs        1.40 μs
insert xlarge         1.65 M        0.61 μs   ±599.77%        0.50 μs        1.50 μs
to_list small         1.08 M        0.93 μs   ±335.66%        0.80 μs        1.80 μs
to_list medium       0.102 M        9.78 μs   ±368.74%           9 μs          19 μs
to_list large      0.00890 M      112.34 μs    ±21.66%         104 μs         215 μs
to_list xlarge     0.00074 M     1360.77 μs    ±19.33%        1269 μs     2511.29 μs

Comparison: 
size large           34.48 M
size xlarge          34.12 M - 1.01x slower
size small           33.84 M - 1.02x slower
size medium          33.74 M - 1.02x slower
peek small           17.00 M - 2.03x slower
peek medium          16.78 M - 2.06x slower
peek large           16.59 M - 2.08x slower
peek xlarge          16.47 M - 2.09x slower
new small             8.35 M - 4.13x slower
new medium            7.09 M - 4.87x slower
new large             6.17 M - 5.59x slower
new xlarge            5.58 M - 6.18x slower
insert small          4.35 M - 7.92x slower
insert medium         2.63 M - 13.11x slower
insert large          1.97 M - 17.55x slower
insert xlarge         1.65 M - 20.86x slower
to_list small         1.08 M - 31.88x slower
to_list medium       0.102 M - 337.27x slower
to_list large      0.00890 M - 3872.89x slower
to_list xlarge     0.00074 M - 46913.41x slower
```
