# Cbuf

A [circular buffer](https://en.wikipedia.org/wiki/Circular_buffer) with implementations built on `queue`, `map` and `ets`.

[![Build Status](https://travis-ci.org/ckampfe/cbuf.svg?branch=master)](https://travis-ci.org/ckampfe/cbuf)

## Installation

```elixir
def deps do
  [
    {:cbuf, "~> 0.7"}
  ]
end
```

See the docs at [https://hexdocs.pm/cbuf](https://hexdocs.pm/cbuf) for usage information.

## Benchmarks

```
$ mix run bench.exs
Compiling 4 files (.ex)
Small N: 50
Medium N: 5000
Small N: 50000
Operating System: macOS"
CPU Information: Intel(R) Core(TM) i7-4578U CPU @ 3.00GHz
Number of Available Cores: 4
Available memory: 16 GB
Elixir 1.7.3
Erlang 21.0.7

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 3 s
parallel: 1
inputs: none specified
Estimated total run time: 15 min


Benchmarking map insert medium...
Benchmarking map size small...
Benchmarking ets insert small...
Benchmarking map insert small...
Benchmarking map size medium...
Benchmarking queue member? medium...
Benchmarking queue count medium...
Benchmarking map to_list small...
Benchmarking queue size large...
Benchmarking queue to_list large...
Benchmarking map member? large...
Benchmarking queue count large...
Benchmarking ets peek small...
Benchmarking map empty? large...
Benchmarking ets count small...
Benchmarking queue new small...
Benchmarking queue empty? medium...
Benchmarking ets insert medium...
Benchmarking map peek small...
Benchmarking ets peek large...
Benchmarking map member? small...
Benchmarking queue insert small...
Benchmarking map pop medium...
Benchmarking map new medium...
Benchmarking ets empty? medium...
Benchmarking ets empty? small...
Benchmarking queue peek small...
Benchmarking map delete medium...
Benchmarking map to_list medium...
Benchmarking queue new medium...
Benchmarking ets pop small...
Benchmarking ets delete large...
Benchmarking ets count large...
Benchmarking map count large...
Benchmarking map peek large...
Benchmarking ets member? large...
Benchmarking map member? medium...
Benchmarking queue delete medium...
Benchmarking ets size small...
Benchmarking ets empty? large...
Benchmarking ets size large...
Benchmarking queue insert large...
Benchmarking map new small...
Benchmarking ets member? medium...
Benchmarking ets new small...
Benchmarking queue count small...
Benchmarking map new large...
Benchmarking map count medium...
Benchmarking queue insert medium...
Benchmarking ets pop large...
Benchmarking queue pop medium...
Benchmarking ets new large...
Benchmarking queue size medium...
Benchmarking queue peek large...
Benchmarking ets delete small...
Benchmarking map delete small...
Benchmarking queue member? small...
Benchmarking map to_list large...
Benchmarking map peek medium...
Benchmarking ets to_list medium...
Benchmarking ets new medium...
Benchmarking map pop large...
Benchmarking map empty? medium...
Benchmarking map insert large...
Benchmarking queue new large...
Benchmarking ets peek medium...
Benchmarking queue delete small...
Benchmarking ets to_list large...
Benchmarking map count small...
Benchmarking queue size small...
Benchmarking map pop small...
Benchmarking queue pop large...
Benchmarking map empty? small...
Benchmarking queue empty? large...
Benchmarking queue member? large...
Benchmarking queue to_list small...
Benchmarking ets pop medium...
Benchmarking ets size medium...
Benchmarking ets to_list small...
Benchmarking ets member? small...
Benchmarking ets delete medium...
Benchmarking queue to_list medium...
Benchmarking map size large...
Benchmarking queue delete large...
Benchmarking map delete large...
Benchmarking ets insert large...
Benchmarking ets count medium...
Benchmarking queue empty? small...
Benchmarking queue peek medium...
Benchmarking queue pop small...

Name                           ips        average  deviation         median         99th %
queue count large          36.63 M      0.0273 μs    ±25.48%      0.0260 μs      0.0505 μs
queue empty? large         36.03 M      0.0278 μs   ±105.62%      0.0260 μs      0.0510 μs
queue empty? medium        36.00 M      0.0278 μs    ±44.66%      0.0260 μs      0.0530 μs
map empty? small           35.66 M      0.0280 μs    ±24.58%      0.0270 μs      0.0530 μs
map empty? large           35.37 M      0.0283 μs   ±140.62%      0.0270 μs      0.0570 μs
ets empty? large           34.61 M      0.0289 μs    ±29.37%      0.0270 μs      0.0590 μs
map size large             34.46 M      0.0290 μs    ±23.70%      0.0280 μs      0.0540 μs
ets size medium            34.23 M      0.0292 μs    ±60.39%      0.0280 μs      0.0540 μs
queue size small           34.12 M      0.0293 μs    ±46.84%      0.0280 μs      0.0550 μs
map empty? medium          32.82 M      0.0305 μs   ±142.15%      0.0270 μs      0.0710 μs
ets size large             32.47 M      0.0308 μs    ±33.63%      0.0280 μs      0.0640 μs
queue empty? small         30.72 M      0.0326 μs   ±137.15%      0.0270 μs      0.0810 μs
ets empty? medium          30.33 M      0.0330 μs   ±164.37%      0.0270 μs       0.101 μs
queue count medium         29.79 M      0.0336 μs   ±208.37%      0.0270 μs      0.0930 μs
queue count small          29.46 M      0.0339 μs   ±206.73%      0.0260 μs       0.117 μs
queue size large           29.32 M      0.0341 μs   ±209.42%      0.0290 μs      0.0770 μs
ets empty? small           27.98 M      0.0357 μs   ±275.08%      0.0270 μs       0.124 μs
ets size small             27.90 M      0.0358 μs   ±206.62%      0.0290 μs      0.0840 μs
queue delete small         27.87 M      0.0359 μs    ±24.88%      0.0340 μs      0.0660 μs
queue delete large         27.75 M      0.0360 μs    ±25.91%      0.0340 μs      0.0670 μs
map size medium            26.56 M      0.0377 μs   ±213.51%      0.0290 μs       0.126 μs
map size small             23.59 M      0.0424 μs   ±293.96%      0.0280 μs       0.182 μs
queue delete medium        22.60 M      0.0442 μs   ±229.87%      0.0340 μs       0.139 μs
queue new large            22.05 M      0.0453 μs   ±741.77%      0.0400 μs       0.110 μs
queue new small            21.55 M      0.0464 μs   ±705.26%      0.0400 μs       0.130 μs
map count small            18.42 M      0.0543 μs   ±106.97%      0.0500 μs      0.0990 μs
queue peek medium          17.97 M      0.0556 μs   ±181.07%      0.0430 μs        0.21 μs
queue peek large           17.75 M      0.0563 μs    ±91.49%      0.0440 μs       0.105 μs
ets count small            17.58 M      0.0569 μs    ±20.47%      0.0550 μs       0.100 μs
queue new medium           17.42 M      0.0574 μs  ±1020.13%      0.0400 μs       0.170 μs
ets count medium           17.29 M      0.0578 μs    ±26.65%      0.0540 μs       0.107 μs
queue peek small           16.93 M      0.0591 μs   ±253.04%      0.0440 μs        0.25 μs
map count large            16.28 M      0.0614 μs   ±136.05%      0.0500 μs        0.24 μs
queue member? large        16.10 M      0.0621 μs    ±62.13%      0.0590 μs       0.118 μs
queue member? small        15.72 M      0.0636 μs    ±29.48%      0.0590 μs       0.130 μs
map count medium           15.19 M      0.0658 μs   ±222.03%      0.0510 μs        0.27 μs
map peek small             14.69 M      0.0681 μs   ±109.37%      0.0600 μs       0.150 μs
ets count large            13.87 M      0.0721 μs   ±195.73%      0.0550 μs        0.30 μs
map peek medium            13.42 M      0.0745 μs    ±58.42%      0.0680 μs       0.167 μs
queue pop large            13.18 M      0.0758 μs   ±402.77%      0.0700 μs       0.150 μs
queue member? medium       12.78 M      0.0783 μs   ±205.67%      0.0620 μs        0.29 μs
queue size medium          11.88 M      0.0841 μs   ±528.56%      0.0660 μs        0.33 μs
map peek large             11.70 M      0.0854 μs   ±204.43%      0.0620 μs        0.37 μs
queue pop small            10.77 M      0.0928 μs   ±397.21%      0.0700 μs        0.26 μs
queue insert medium         7.10 M       0.141 μs   ±356.41%       0.110 μs        0.55 μs
queue pop medium            5.58 M       0.179 μs   ±514.13%       0.150 μs        0.34 μs
map delete small            5.38 M       0.186 μs   ±123.45%       0.170 μs        0.43 μs
ets delete medium           4.88 M        0.20 μs    ±45.59%       0.190 μs        0.47 μs
queue to_list small         4.77 M        0.21 μs  ±1686.38%        0.20 μs        0.40 μs
ets delete small            4.69 M        0.21 μs    ±61.64%       0.190 μs        0.50 μs
ets insert large            4.62 M        0.22 μs    ±47.82%        0.20 μs        0.46 μs
ets insert medium           4.52 M        0.22 μs   ±125.01%        0.20 μs        0.52 μs
map insert small            4.35 M        0.23 μs   ±296.94%       0.170 μs        0.68 μs
map insert large            4.11 M        0.24 μs    ±40.60%        0.23 μs        0.63 μs
map pop small               4.11 M        0.24 μs    ±36.37%        0.23 μs        0.50 μs
ets delete large            4.00 M        0.25 μs   ±208.24%       0.190 μs        0.85 μs
map delete large            3.97 M        0.25 μs    ±41.12%        0.23 μs        0.64 μs
ets insert small            3.84 M        0.26 μs   ±204.22%        0.20 μs        0.89 μs
map insert medium           3.21 M        0.31 μs   ±565.96%        0.20 μs        1.10 μs
map pop large               2.93 M        0.34 μs  ±1451.56%        0.30 μs        0.80 μs
queue insert small          2.85 M        0.35 μs  ±8990.95%           0 μs           1 μs
map pop medium              2.83 M        0.35 μs   ±219.67%        0.27 μs        1.20 μs
queue insert large          2.80 M        0.36 μs  ±8678.14%           0 μs           1 μs
map delete medium           2.69 M        0.37 μs  ±1712.81%        0.20 μs        1.20 μs
ets peek small              1.58 M        0.63 μs  ±1379.49%           1 μs           1 μs
ets peek large              1.54 M        0.65 μs  ±3721.00%           1 μs           1 μs
ets peek medium             1.50 M        0.67 μs  ±1036.64%           1 μs           1 μs
ets pop medium              1.08 M        0.92 μs  ±3533.92%           1 μs           2 μs
ets pop small               0.92 M        1.09 μs  ±3857.43%           1 μs           2 μs
ets pop large               0.76 M        1.31 μs  ±4378.21%           1 μs           3 μs
ets member? small           0.28 M        3.52 μs   ±402.66%           3 μs           7 μs
map member? small          0.187 M        5.35 μs   ±695.57%           4 μs          16 μs
map to_list small          0.127 M        7.89 μs   ±687.96%           6 μs          20 μs
map new small              0.104 M        9.61 μs   ±531.81%           7 μs          39 μs
queue to_list medium      0.0461 M       21.67 μs   ±202.52%          13 μs          96 μs
ets to_list small         0.0398 M       25.14 μs    ±39.17%          24 μs          48 μs
ets new small             0.0240 M       41.63 μs   ±179.30%          34 μs         156 μs
queue to_list large      0.00404 M      247.65 μs    ±87.71%         108 μs         708 μs
ets member? medium       0.00349 M      286.87 μs   ±159.94%         195 μs     2039.06 μs
map member? medium       0.00232 M      431.61 μs    ±82.39%         338 μs     2453.11 μs
map to_list medium       0.00111 M      898.77 μs    ±71.95%         694 μs     3567.06 μs
map new medium           0.00055 M     1808.78 μs    ±45.66%        1600 μs        5512 μs
ets to_list medium       0.00033 M     2996.67 μs    ±15.41%        2861 μs     5354.17 μs
ets new medium           0.00029 M     3453.91 μs    ±15.59%        3324 μs     5801.12 μs
map member? large        0.00027 M     3716.72 μs    ±12.30%        3531 μs     5552.95 μs
ets member? large        0.00016 M     6147.96 μs    ±36.04%        5526 μs    13708.14 μs
map to_list large        0.00007 M    13372.52 μs    ±18.76%       12578 μs       22136 μs
map new large            0.00004 M    24491.32 μs    ±19.78%       23412 μs    40776.10 μs
ets to_list large        0.00003 M    36548.49 μs    ±13.48%       35461 μs    59262.10 μs
ets new large            0.00002 M    55398.77 μs    ±32.20%       52066 μs      192133 μs

Comparison: 
queue count large          36.63 M
queue empty? large         36.03 M - 1.02x slower
queue empty? medium        36.00 M - 1.02x slower
map empty? small           35.66 M - 1.03x slower
map empty? large           35.37 M - 1.04x slower
ets empty? large           34.61 M - 1.06x slower
map size large             34.46 M - 1.06x slower
ets size medium            34.23 M - 1.07x slower
queue size small           34.12 M - 1.07x slower
map empty? medium          32.82 M - 1.12x slower
ets size large             32.47 M - 1.13x slower
queue empty? small         30.72 M - 1.19x slower
ets empty? medium          30.33 M - 1.21x slower
queue count medium         29.79 M - 1.23x slower
queue count small          29.46 M - 1.24x slower
queue size large           29.32 M - 1.25x slower
ets empty? small           27.98 M - 1.31x slower
ets size small             27.90 M - 1.31x slower
queue delete small         27.87 M - 1.31x slower
queue delete large         27.75 M - 1.32x slower
map size medium            26.56 M - 1.38x slower
map size small             23.59 M - 1.55x slower
queue delete medium        22.60 M - 1.62x slower
queue new large            22.05 M - 1.66x slower
queue new small            21.55 M - 1.70x slower
map count small            18.42 M - 1.99x slower
queue peek medium          17.97 M - 2.04x slower
queue peek large           17.75 M - 2.06x slower
ets count small            17.58 M - 2.08x slower
queue new medium           17.42 M - 2.10x slower
ets count medium           17.29 M - 2.12x slower
queue peek small           16.93 M - 2.16x slower
map count large            16.28 M - 2.25x slower
queue member? large        16.10 M - 2.28x slower
queue member? small        15.72 M - 2.33x slower
map count medium           15.19 M - 2.41x slower
map peek small             14.69 M - 2.49x slower
ets count large            13.87 M - 2.64x slower
map peek medium            13.42 M - 2.73x slower
queue pop large            13.18 M - 2.78x slower
queue member? medium       12.78 M - 2.87x slower
queue size medium          11.88 M - 3.08x slower
map peek large             11.70 M - 3.13x slower
queue pop small            10.77 M - 3.40x slower
queue insert medium         7.10 M - 5.16x slower
queue pop medium            5.58 M - 6.57x slower
map delete small            5.38 M - 6.81x slower
ets delete medium           4.88 M - 7.51x slower
queue to_list small         4.77 M - 7.68x slower
ets delete small            4.69 M - 7.82x slower
ets insert large            4.62 M - 7.94x slower
ets insert medium           4.52 M - 8.10x slower
map insert small            4.35 M - 8.43x slower
map insert large            4.11 M - 8.91x slower
map pop small               4.11 M - 8.92x slower
ets delete large            4.00 M - 9.16x slower
map delete large            3.97 M - 9.24x slower
ets insert small            3.84 M - 9.54x slower
map insert medium           3.21 M - 11.42x slower
map pop large               2.93 M - 12.49x slower
queue insert small          2.85 M - 12.85x slower
map pop medium              2.83 M - 12.92x slower
queue insert large          2.80 M - 13.09x slower
map delete medium           2.69 M - 13.64x slower
ets peek small              1.58 M - 23.23x slower
ets peek large              1.54 M - 23.75x slower
ets peek medium             1.50 M - 24.41x slower
ets pop medium              1.08 M - 33.83x slower
ets pop small               0.92 M - 39.99x slower
ets pop large               0.76 M - 48.11x slower
ets member? small           0.28 M - 128.91x slower
map member? small          0.187 M - 195.92x slower
map to_list small          0.127 M - 289.21x slower
map new small              0.104 M - 352.05x slower
queue to_list medium      0.0461 M - 794.03x slower
ets to_list small         0.0398 M - 921.15x slower
ets new small             0.0240 M - 1525.20x slower
queue to_list large      0.00404 M - 9072.67x slower
ets member? medium       0.00349 M - 10509.47x slower
map member? medium       0.00232 M - 15811.88x slower
map to_list medium       0.00111 M - 32926.41x slower
map new medium           0.00055 M - 66264.49x slower
ets to_list medium       0.00033 M - 109782.81x slower
ets new medium           0.00029 M - 126533.86x slower
map member? large        0.00027 M - 136162.14x slower
ets member? large        0.00016 M - 225230.34x slower
map to_list large        0.00007 M - 489902.18x slower
map new large            0.00004 M - 897239.20x slower
ets to_list large        0.00003 M - 1338953.51x slower
ets new large            0.00002 M - 2029533.33x slower

Memory usage statistics:

Name                    Memory usage
queue count large              144 B
queue empty? large             144 B - 1.00x memory usage
queue empty? medium            144 B - 1.00x memory usage
map empty? small              1672 B - 11.61x memory usage
map empty? large           1475592 B - 10247.17x memory usage
ets empty? large               176 B - 1.22x memory usage
map size large             1475592 B - 10247.17x memory usage
ets size medium                176 B - 1.22x memory usage
queue size small               144 B - 1.00x memory usage
map empty? medium           149688 B - 1039.50x memory usage
ets size large                 176 B - 1.22x memory usage
queue empty? small             144 B - 1.00x memory usage
ets empty? medium              176 B - 1.22x memory usage
queue count medium             144 B - 1.00x memory usage
queue count small              144 B - 1.00x memory usage
queue size large               144 B - 1.00x memory usage
ets empty? small               176 B - 1.22x memory usage
ets size small                 176 B - 1.22x memory usage
queue delete small             144 B - 1.00x memory usage
queue delete large             144 B - 1.00x memory usage
map size medium             149688 B - 1039.50x memory usage
map size small                1672 B - 11.61x memory usage
queue delete medium            144 B - 1.00x memory usage
queue new large                136 B - 0.94x memory usage
queue new small                136 B - 0.94x memory usage
map count small               1672 B - 11.61x memory usage
queue peek medium              144 B - 1.00x memory usage
queue peek large               144 B - 1.00x memory usage
ets count small                176 B - 1.22x memory usage
queue new medium               136 B - 0.94x memory usage
ets count medium               176 B - 1.22x memory usage
queue peek small               144 B - 1.00x memory usage
map count large            1475592 B - 10247.17x memory usage
queue member? large            144 B - 1.00x memory usage
queue member? small            144 B - 1.00x memory usage
map count medium            149688 B - 1039.50x memory usage
map peek small                1672 B - 11.61x memory usage
ets count large                176 B - 1.22x memory usage
map peek medium             149688 B - 1039.50x memory usage
queue pop large                168 B - 1.17x memory usage
queue member? medium           144 B - 1.00x memory usage
queue size medium              144 B - 1.00x memory usage
map peek large             1475592 B - 10247.17x memory usage
queue pop small                168 B - 1.17x memory usage
queue insert medium            248 B - 1.72x memory usage
queue pop medium               168 B - 1.17x memory usage
map delete small              1944 B - 13.50x memory usage
ets delete medium              272 B - 1.89x memory usage
queue to_list small           1776 B - 12.33x memory usage
ets delete small               272 B - 1.89x memory usage
ets insert large               272 B - 1.89x memory usage
ets insert medium              272 B - 1.89x memory usage
map insert small              1944 B - 13.50x memory usage
map insert large           1476168 B - 10251.17x memory usage
map pop small                 1968 B - 13.67x memory usage
ets delete large               272 B - 1.89x memory usage
map delete large           1476168 B - 10251.17x memory usage
ets insert small               272 B - 1.89x memory usage
map insert medium           150192 B - 1043.00x memory usage
map pop large              1476192 B - 10251.33x memory usage
queue insert small             248 B - 1.72x memory usage
map pop medium              150216 B - 1043.17x memory usage
queue insert large             248 B - 1.72x memory usage
map delete medium           150192 B - 1043.00x memory usage
ets peek small                 256 B - 1.78x memory usage
ets peek large                 232 B - 1.61x memory usage
ets peek medium                256 B - 1.78x memory usage
ets pop medium                 352 B - 2.44x memory usage
ets pop small                  352 B - 2.44x memory usage
ets pop large                  352 B - 2.44x memory usage
ets member? small              240 B - 1.67x memory usage
map member? small             4528 B - 31.44x memory usage
map to_list small             6872 B - 47.72x memory usage
map new small                12904 B - 89.61x memory usage
queue to_list medium         87568 B - 608.11x memory usage
ets to_list small             7520 B - 52.22x memory usage
ets new small                 1528 B - 10.61x memory usage
queue to_list large         972192 B - 6751.33x memory usage
ets member? medium             488 B - 3.39x memory usage
map member? medium          270544 B - 1878.78x memory usage
map to_list medium          634776 B - 4408.17x memory usage
map new medium             1832320 B - 12724.44x memory usage
ets to_list medium          723960 B - 5027.50x memory usage
ets new medium              120328 B - 835.61x memory usage
map member? large          2676448 B - 18586.44x memory usage
ets member? large             2952 B - 20.50x memory usage
map to_list large          6002784 B - 41686.00x memory usage
map new large             23990664 B - 166601.83x memory usage
ets to_list large          7342208 B - 50987.56x memory usage
ets new large              1200328 B - 8335.61x memory usage

**All measurements for memory usage were the same**
```
