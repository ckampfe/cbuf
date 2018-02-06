# Cbuf

A [circular buffer](https://en.wikipedia.org/wiki/Circular_buffer) based on Erlang's `array` module.

## Installation

```elixir
def deps do
  [
    {:cbuf, "~> 0.4"}
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
Estimated total run time: 4.20 min


Benchmarking empty? small...
Benchmarking size xlarge...
Benchmarking new medium...
Benchmarking new large...
Benchmarking delete large...
Benchmarking pop small...
Benchmarking count large...
Benchmarking new xlarge...
Benchmarking insert medium...
Benchmarking delete medium...
Benchmarking pop large...
Benchmarking to_list small...
Benchmarking size medium...
Benchmarking insert xlarge...
Benchmarking new small...
Benchmarking size small...
Benchmarking empty? medium...
Benchmarking to_list large...
Benchmarking count xlarge...
Benchmarking to_list medium...
Benchmarking peek large...
Benchmarking peek medium...
Benchmarking insert small...
Benchmarking peek xlarge...
Benchmarking delete small...
Benchmarking peek small...
Benchmarking size large...
Benchmarking empty? xlarge...
Benchmarking insert large...
Benchmarking delete xlarge...
Benchmarking pop medium...
Benchmarking count small...
Benchmarking to_list xlarge...
Benchmarking empty? large...
Benchmarking count medium...
Benchmarking pop xlarge...

Name                     ips        average  deviation         median         99th %
empty? large         38.24 M      0.0262 μs    ±21.57%      0.0250 μs      0.0520 μs
empty? medium        35.86 M      0.0279 μs    ±22.63%      0.0260 μs      0.0530 μs
empty? small         35.62 M      0.0281 μs    ±29.00%      0.0250 μs      0.0530 μs
empty? xlarge        34.99 M      0.0286 μs    ±24.36%      0.0260 μs      0.0540 μs
size small           33.40 M      0.0299 μs    ±24.13%      0.0270 μs      0.0560 μs
size large           33.16 M      0.0302 μs    ±35.87%      0.0280 μs      0.0570 μs
size medium          32.97 M      0.0303 μs    ±23.66%      0.0280 μs      0.0560 μs
size xlarge          30.64 M      0.0326 μs    ±28.85%      0.0280 μs      0.0670 μs
count small          18.31 M      0.0546 μs    ±79.30%      0.0500 μs       0.110 μs
count medium         18.12 M      0.0552 μs    ±20.86%      0.0510 μs       0.107 μs
count xlarge         17.52 M      0.0571 μs    ±20.70%      0.0520 μs       0.108 μs
count large          17.50 M      0.0572 μs    ±21.15%      0.0530 μs       0.108 μs
peek medium          16.58 M      0.0603 μs    ±20.14%      0.0550 μs       0.116 μs
peek small           16.49 M      0.0606 μs    ±19.77%      0.0560 μs       0.116 μs
peek xlarge          16.40 M      0.0610 μs    ±20.37%      0.0560 μs       0.116 μs
peek large           16.16 M      0.0619 μs    ±20.59%      0.0570 μs       0.116 μs
new small             9.01 M       0.111 μs   ±317.36%       0.100 μs        0.30 μs
new medium            7.54 M       0.133 μs   ±247.05%       0.120 μs        0.39 μs
new large             6.49 M       0.154 μs   ±131.39%       0.140 μs        0.42 μs
new xlarge            5.87 M       0.171 μs   ±131.54%       0.160 μs        0.41 μs
delete small          4.82 M        0.21 μs    ±77.09%       0.190 μs        0.49 μs
insert small          4.67 M        0.21 μs    ±94.16%        0.20 μs        0.42 μs
pop small             3.10 M        0.32 μs  ±1563.27%        0.30 μs        0.70 μs
insert medium         2.82 M        0.36 μs  ±1644.08%        0.30 μs        0.70 μs
delete medium         2.81 M        0.36 μs  ±1553.59%        0.30 μs        0.70 μs
pop medium            2.44 M        0.41 μs  ±1052.78%        0.40 μs        0.80 μs
insert large          2.13 M        0.47 μs   ±797.70%        0.40 μs        1.30 μs
delete large          2.11 M        0.47 μs  ±1199.73%        0.40 μs        1.20 μs
pop large             1.88 M        0.53 μs   ±758.25%        0.50 μs        1.40 μs
delete xlarge         1.72 M        0.58 μs   ±831.95%        0.50 μs        1.50 μs
insert xlarge         1.71 M        0.59 μs   ±671.17%        0.50 μs        1.50 μs
pop xlarge            1.55 M        0.64 μs   ±521.96%        0.60 μs        1.60 μs
to_list small         1.30 M        0.77 μs   ±510.96%        0.70 μs        1.60 μs
to_list medium       0.122 M        8.19 μs   ±501.09%           7 μs          17 μs
to_list large       0.0104 M       96.18 μs    ±20.19%          89 μs         184 μs
to_list xlarge     0.00080 M     1254.46 μs    ±18.61%        1188 μs     2248.17 μs

Comparison:
empty? large         38.24 M
empty? medium        35.86 M - 1.07x slower
empty? small         35.62 M - 1.07x slower
empty? xlarge        34.99 M - 1.09x slower
size small           33.40 M - 1.14x slower
size large           33.16 M - 1.15x slower
size medium          32.97 M - 1.16x slower
size xlarge          30.64 M - 1.25x slower
count small          18.31 M - 2.09x slower
count medium         18.12 M - 2.11x slower
count xlarge         17.52 M - 2.18x slower
count large          17.50 M - 2.19x slower
peek medium          16.58 M - 2.31x slower
peek small           16.49 M - 2.32x slower
peek xlarge          16.40 M - 2.33x slower
peek large           16.16 M - 2.37x slower
new small             9.01 M - 4.25x slower
new medium            7.54 M - 5.07x slower
new large             6.49 M - 5.89x slower
new xlarge            5.87 M - 6.52x slower
delete small          4.82 M - 7.93x slower
insert small          4.67 M - 8.19x slower
pop small             3.10 M - 12.33x slower
insert medium         2.82 M - 13.58x slower
delete medium         2.81 M - 13.63x slower
pop medium            2.44 M - 15.66x slower
insert large          2.13 M - 17.92x slower
delete large          2.11 M - 18.14x slower
pop large             1.88 M - 20.34x slower
delete xlarge         1.72 M - 22.22x slower
insert xlarge         1.71 M - 22.43x slower
pop xlarge            1.55 M - 24.63x slower
to_list small         1.30 M - 29.45x slower
to_list medium       0.122 M - 313.17x slower
to_list large       0.0104 M - 3677.75x slower
to_list xlarge     0.00080 M - 47966.13x slower
```
