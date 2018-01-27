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
Estimated total run time: 1.40 min


Benchmarking insert large...
Benchmarking insert medium...
Benchmarking insert small...
Benchmarking insert xlarge...
Benchmarking new large...
Benchmarking new medium...
Benchmarking new small...
Benchmarking new xlarge...
Benchmarking to_list large...
Benchmarking to_list medium...
Benchmarking to_list small...
Benchmarking to_list xlarge...

Name                     ips        average  deviation         median         99th %
new small             8.18 M       0.122 μs   ±274.93%       0.100 μs        0.42 μs
new medium            7.13 M       0.140 μs   ±148.68%       0.120 μs        0.41 μs
new large             6.17 M       0.162 μs   ±144.69%       0.140 μs        0.46 μs
new xlarge            4.48 M        0.22 μs  ±3125.43%        0.20 μs        0.80 μs
insert small          3.50 M        0.29 μs  ±1990.99%        0.20 μs           1 μs
insert medium         2.52 M        0.40 μs  ±1533.98%        0.30 μs        1.20 μs
insert large          1.91 M        0.53 μs   ±888.86%        0.40 μs        1.50 μs
insert xlarge         1.57 M        0.64 μs   ±627.99%        0.60 μs        1.70 μs
to_list small         1.04 M        0.97 μs   ±320.93%        0.80 μs        2.40 μs
to_list medium      0.0963 M       10.38 μs   ±365.00%           9 μs          25 μs
to_list large      0.00865 M      115.66 μs    ±24.56%         107 μs         222 μs
to_list xlarge     0.00071 M     1416.13 μs    ±18.80%        1334 μs     2576.46 μs

Comparison:
new small             8.18 M
new medium            7.13 M - 1.15x slower
new large             6.17 M - 1.32x slower
new xlarge            4.48 M - 1.82x slower
insert small          3.50 M - 2.34x slower
insert medium         2.52 M - 3.25x slower
insert large          1.91 M - 4.29x slower
insert xlarge         1.57 M - 5.22x slower
to_list small         1.04 M - 7.91x slower
to_list medium      0.0963 M - 84.91x slower
to_list large      0.00865 M - 946.01x slower
to_list xlarge     0.00071 M - 11582.50x slower
```
