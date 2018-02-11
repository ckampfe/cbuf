# Cbuf

A [circular buffer](https://en.wikipedia.org/wiki/Circular_buffer) with implementations built on `map` and `ets`.

## Installation

```elixir
def deps do
  [
    {:cbuf, "~> 0.5"}
  ]
end
```

See the docs at [https://hexdocs.pm/cbuf](https://hexdocs.pm/cbuf) for usage information.

## Benchmarks

```
clark$> mix run bench.exs
Small N: 50
Medium N: 5000
Small N: 50000
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-4870HQ CPU @ 2.50GHz
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.6.1
Erlang 20.2.2
Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
parallel: 4
inputs: none specified
Estimated total run time: 7 min


Benchmarking ets count medium...
Benchmarking ets insert large...
Benchmarking map delete large...
Benchmarking map size large...
Benchmarking ets delete medium...
Benchmarking ets member? small...
Benchmarking ets to_list small...
Benchmarking ets size medium...
Benchmarking ets pop medium...
Benchmarking map empty? small...
Benchmarking map pop small...
Benchmarking map count small...
Benchmarking ets to_list large...
Benchmarking ets peek medium...
Benchmarking map insert large...
Benchmarking map empty? medium...
Benchmarking map pop large...
Benchmarking ets new medium...
Benchmarking ets to_list medium...
Benchmarking map peek medium...
Benchmarking map to_list large...
Benchmarking map delete small...
Benchmarking ets delete small...
Benchmarking ets new large...
Benchmarking ets pop large...
Benchmarking map count medium...
Benchmarking map new large...
Benchmarking ets new small...
Benchmarking ets member? medium...
Benchmarking map new small...
Benchmarking ets size large...
Benchmarking ets empty? large...
Benchmarking ets size small...
Benchmarking map member? medium...
Benchmarking ets member? large...
Benchmarking map peek large...
Benchmarking map count large...
Benchmarking ets count large...
Benchmarking ets delete large...
Benchmarking ets pop small...
Benchmarking map to_list medium...
Benchmarking map delete medium...
Benchmarking ets empty? small...
Benchmarking ets empty? medium...
Benchmarking map new medium...
Benchmarking map pop medium...
Benchmarking map member? small...
Benchmarking ets peek large...
Benchmarking map peek small...
Benchmarking ets insert medium...
Benchmarking ets count small...
Benchmarking map empty? large...
Benchmarking ets peek small...
Benchmarking map member? large...
Benchmarking map to_list small...
Benchmarking map size medium...
Benchmarking map insert small...
Benchmarking ets insert small...
Benchmarking map size small...
Benchmarking map insert medium...

Name                         ips        average  deviation         median         99th %
map empty? medium        31.22 M      0.0320 μs    ±83.97%      0.0300 μs      0.0590 μs
map size large           31.05 M      0.0322 μs    ±77.56%      0.0310 μs      0.0580 μs
ets size medium          29.83 M      0.0335 μs    ±38.91%      0.0320 μs      0.0620 μs
ets empty? large         29.49 M      0.0339 μs    ±33.61%      0.0320 μs      0.0600 μs
ets empty? small         28.71 M      0.0348 μs    ±23.05%      0.0320 μs      0.0640 μs
ets empty? medium        28.56 M      0.0350 μs    ±23.65%      0.0320 μs      0.0680 μs
ets size large           28.14 M      0.0355 μs    ±37.91%      0.0320 μs      0.0690 μs
map size medium          27.94 M      0.0358 μs    ±24.73%      0.0330 μs      0.0670 μs
map empty? large         27.68 M      0.0361 μs    ±24.58%      0.0330 μs      0.0680 μs
ets size small           27.26 M      0.0367 μs    ±99.89%      0.0340 μs      0.0690 μs
map size small           26.40 M      0.0379 μs   ±299.37%      0.0320 μs       0.100 μs
ets count medium         16.55 M      0.0604 μs    ±56.37%      0.0600 μs       0.110 μs
map count medium         15.35 M      0.0651 μs    ±64.47%      0.0600 μs       0.120 μs
map count small          15.17 M      0.0659 μs   ±288.40%      0.0600 μs       0.120 μs
map count large          15.06 M      0.0664 μs   ±105.84%      0.0600 μs       0.130 μs
ets count small          14.95 M      0.0669 μs    ±39.52%      0.0620 μs       0.130 μs
ets count large          14.94 M      0.0669 μs    ±47.91%      0.0630 μs       0.130 μs
map peek large           11.52 M      0.0868 μs    ±51.89%      0.0800 μs       0.180 μs
map peek medium          11.12 M      0.0899 μs   ±115.14%      0.0820 μs       0.190 μs
map peek small           10.96 M      0.0913 μs   ±221.72%      0.0800 μs       0.190 μs
map empty? small          6.06 M       0.165 μs   ±227.60%           0 μs           1 μs
map delete small          4.18 M        0.24 μs   ±102.60%        0.21 μs        1.89 μs
map insert small          4.14 M        0.24 μs    ±93.51%        0.21 μs        1.84 μs
map pop small             3.36 M        0.30 μs    ±79.15%        0.28 μs        0.60 μs
map delete large          3.36 M        0.30 μs  ±1653.92%        0.21 μs        1.92 μs
map delete medium         3.30 M        0.30 μs  ±1252.38%        0.25 μs        0.60 μs
map insert medium         3.14 M        0.32 μs   ±109.24%        0.24 μs        2.19 μs
map insert large          3.09 M        0.32 μs  ±1350.73%        0.30 μs        0.60 μs
map pop large             2.34 M        0.43 μs   ±809.80%        0.40 μs        0.81 μs
map pop medium            2.19 M        0.46 μs  ±1204.54%        0.30 μs        1.10 μs
ets peek medium           1.47 M        0.68 μs   ±507.39%        0.63 μs        1.20 μs
ets peek small            1.47 M        0.68 μs   ±554.57%        0.60 μs        1.30 μs
ets peek large            1.45 M        0.69 μs   ±467.56%        0.64 μs        1.30 μs
ets member? small         0.24 M        4.24 μs   ±652.64%           4 μs           8 μs
map member? small        0.169 M        5.94 μs   ±942.22%           5 μs          13 μs
ets insert small         0.156 M        6.39 μs    ±46.70%        6.40 μs       13.70 μs
ets insert medium        0.156 M        6.39 μs    ±49.78%        6.30 μs       14.40 μs
ets delete small         0.142 M        7.03 μs    ±44.53%        7.03 μs       14.50 μs
ets insert large         0.126 M        7.95 μs   ±279.23%        5.80 μs          32 μs
ets delete medium        0.121 M        8.25 μs   ±223.99%        5.70 μs          31 μs
map to_list small        0.119 M        8.40 μs   ±585.01%           7 μs          15 μs
ets delete large         0.114 M        8.77 μs   ±228.22%        6.37 μs          35 μs
map new small           0.0904 M       11.06 μs   ±404.22%           8 μs         132 μs
ets pop medium          0.0567 M       17.64 μs    ±26.31%       17.60 μs       28.60 μs
ets pop small           0.0548 M       18.27 μs   ±100.24%          17 μs          49 μs
ets pop large           0.0508 M       19.67 μs    ±93.53%          18 μs          53 μs
ets to_list small       0.0287 M       34.86 μs    ±29.46%          35 μs          43 μs
ets new small           0.0272 M       36.76 μs    ±45.14%          36 μs          57 μs
ets member? medium     0.00361 M      277.09 μs    ±17.09%         268 μs         479 μs
map member? medium     0.00228 M      437.87 μs    ±11.20%         427 μs      752.55 μs
map to_list medium     0.00122 M      821.78 μs    ±11.36%         809 μs     1429.76 μs
map new medium         0.00054 M     1851.17 μs    ±23.16%        1719 μs     3253.09 μs
ets member? large      0.00034 M     2961.39 μs    ±10.02%        2881 μs     4714.44 μs
ets new medium         0.00029 M     3476.30 μs    ±12.71%        3591 μs        4102 μs
ets to_list medium     0.00024 M     4197.38 μs    ±19.38%        3942 μs     7367.34 μs
map member? large      0.00019 M     5289.42 μs    ±16.55%        4928 μs     8199.65 μs
map to_list large      0.00007 M    15199.72 μs    ±17.11%       14783 μs    22345.60 μs
map new large          0.00004 M    25682.00 μs    ±13.82%       25314 μs    35804.93 μs
ets new large          0.00003 M    36430.22 μs    ±11.77%    36253.50 μs    45945.20 μs
ets to_list large      0.00002 M    43671.84 μs     ±7.02%       43567 μs    60286.94 μs

Comparison:
map empty? medium        31.22 M
map size large           31.05 M - 1.01x slower
ets size medium          29.83 M - 1.05x slower
ets empty? large         29.49 M - 1.06x slower
ets empty? small         28.71 M - 1.09x slower
ets empty? medium        28.56 M - 1.09x slower
ets size large           28.14 M - 1.11x slower
map size medium          27.94 M - 1.12x slower
map empty? large         27.68 M - 1.13x slower
ets size small           27.26 M - 1.15x slower
map size small           26.40 M - 1.18x slower
ets count medium         16.55 M - 1.89x slower
map count medium         15.35 M - 2.03x slower
map count small          15.17 M - 2.06x slower
map count large          15.06 M - 2.07x slower
ets count small          14.95 M - 2.09x slower
ets count large          14.94 M - 2.09x slower
map peek large           11.52 M - 2.71x slower
map peek medium          11.12 M - 2.81x slower
map peek small           10.96 M - 2.85x slower
map empty? small          6.06 M - 5.15x slower
map delete small          4.18 M - 7.47x slower
map insert small          4.14 M - 7.54x slower
map pop small             3.36 M - 9.29x slower
map delete large          3.36 M - 9.30x slower
map delete medium         3.30 M - 9.46x slower
map insert medium         3.14 M - 9.95x slower
map insert large          3.09 M - 10.10x slower
map pop large             2.34 M - 13.34x slower
map pop medium            2.19 M - 14.26x slower
ets peek medium           1.47 M - 21.23x slower
ets peek small            1.47 M - 21.30x slower
ets peek large            1.45 M - 21.57x slower
ets member? small         0.24 M - 132.29x slower
map member? small        0.169 M - 185.29x slower
ets insert small         0.156 M - 199.57x slower
ets insert medium        0.156 M - 199.64x slower
ets delete small         0.142 M - 219.59x slower
ets insert large         0.126 M - 248.15x slower
ets delete medium        0.121 M - 257.42x slower
map to_list small        0.119 M - 262.09x slower
ets delete large         0.114 M - 273.78x slower
map new small           0.0904 M - 345.23x slower
ets pop medium          0.0567 M - 550.65x slower
ets pop small           0.0548 M - 570.28x slower
ets pop large           0.0508 M - 614.11x slower
ets to_list small       0.0287 M - 1088.44x slower
ets new small           0.0272 M - 1147.63x slower
ets member? medium     0.00361 M - 8651.04x slower
map member? medium     0.00228 M - 13670.95x slower
map to_list medium     0.00122 M - 25657.40x slower
map new medium         0.00054 M - 57796.44x slower
ets member? large      0.00034 M - 92459.48x slower
ets new medium         0.00029 M - 108535.84x slower
ets to_list medium     0.00024 M - 131049.30x slower
map member? large      0.00019 M - 165144.57x slower
map to_list large      0.00007 M - 474560.63x slower
map new large          0.00004 M - 801834.66x slower
ets new large          0.00003 M - 1137411.90x slower
ets to_list large      0.00002 M - 1363507.31x slower
```
