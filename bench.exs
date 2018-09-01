small = 50
medium = 5000
large = 50_000

IO.puts("Small N: #{small}")
IO.puts("Medium N: #{medium}")
IO.puts("Small N: #{large}")

map_small = Cbuf.Map.new(small)
map_medium = Cbuf.Map.new(medium)
map_large = Cbuf.Map.new(large)

ets_small = Cbuf.ETS.new(small)
ets_medium = Cbuf.ETS.new(medium)
ets_large = Cbuf.ETS.new(large)

queue_small = Cbuf.Queue.new(small)
queue_medium = Cbuf.Queue.new(medium)
queue_large = Cbuf.Queue.new(large)

str = "ok"

map_filled_small = Enum.reduce(1..small, map_small, fn(val, buf) -> Cbuf.Map.insert(buf, val) end)
map_filled_medium = Enum.reduce(1..medium, map_medium, fn(val, buf) -> Cbuf.Map.insert(buf, val) end)
map_filled_large = Enum.reduce(1..large, map_large, fn(val, buf) -> Cbuf.Map.insert(buf, val) end)

ets_filled_small = Enum.reduce(1..small, ets_small, fn(val, buf) -> Cbuf.ETS.insert(buf, val) end)
ets_filled_medium = Enum.reduce(1..medium, ets_medium, fn(val, buf) -> Cbuf.ETS.insert(buf, val) end)
ets_filled_large = Enum.reduce(1..large, ets_large, fn(val, buf) -> Cbuf.ETS.insert(buf, val) end)

queue_filled_small = Enum.reduce(1..small, queue_small, fn(val, buf) -> Cbuf.Queue.insert(buf, val) end)
queue_filled_medium = Enum.reduce(1..medium, queue_medium, fn(val, buf) -> Cbuf.Queue.insert(buf, val) end)
queue_filled_large = Enum.reduce(1..large, queue_large, fn(val, buf) -> Cbuf.Queue.insert(buf, val) end)

benchmarks = %{
  "map insert small" => fn -> Cbuf.Map.insert(map_small, str) end,
  "map insert medium" => fn -> Cbuf.Map.insert(map_medium, str) end,
  "map insert large" => fn -> Cbuf.Map.insert(map_large, str) end,

  "map to_list small" => fn -> Cbuf.Map.to_list(map_filled_small) end,
  "map to_list medium" => fn -> Cbuf.Map.to_list(map_filled_medium) end,
  "map to_list large" => fn -> Cbuf.Map.to_list(map_filled_large) end,

  "map new small" => fn -> Cbuf.Map.new(small) end,
  "map new medium" => fn -> Cbuf.Map.new(medium) end,
  "map new large" => fn -> Cbuf.Map.new(large) end,

  "map peek small" => fn -> Cbuf.Map.peek(map_small) end,
  "map peek medium" => fn -> Cbuf.Map.peek(map_medium) end,
  "map peek large" => fn -> Cbuf.Map.peek(map_large) end,

  "map size small" => fn -> Cbuf.Map.size(map_small) end,
  "map size medium" => fn -> Cbuf.Map.size(map_medium) end,
  "map size large" => fn -> Cbuf.Map.size(map_large) end,

  "map count small" => fn -> Cbuf.Map.count(map_small) end,
  "map count medium" => fn -> Cbuf.Map.count(map_medium) end,
  "map count large" => fn -> Cbuf.Map.count(map_large) end,

  "map delete small" => fn -> Cbuf.Map.delete(map_small) end,
  "map delete medium" => fn -> Cbuf.Map.delete(map_medium) end,
  "map delete large" => fn -> Cbuf.Map.delete(map_large) end,

  "map pop small" => fn -> Cbuf.Map.pop(map_small) end,
  "map pop medium" => fn -> Cbuf.Map.pop(map_medium) end,
  "map pop large" => fn -> Cbuf.Map.pop(map_large) end,

  "map empty? small" => fn -> Cbuf.Map.empty?(map_small) end,
  "map empty? medium" => fn -> Cbuf.Map.empty?(map_medium) end,
  "map empty? large" => fn -> Cbuf.Map.empty?(map_large) end,

  "map member? small" => fn -> Cbuf.Map.member?(map_small, 3) end,
  "map member? medium" => fn -> Cbuf.Map.member?(map_medium, 300) end,
  "map member? large" => fn -> Cbuf.Map.member?(map_large, 30000) end,

  "ets insert small" => fn -> Cbuf.ETS.insert(ets_small, str) end,
  "ets insert medium" => fn -> Cbuf.ETS.insert(ets_medium, str) end,
  "ets insert large" => fn -> Cbuf.ETS.insert(ets_large, str) end,

  "ets to_list small" => fn -> Cbuf.ETS.to_list(ets_filled_small) end,
  "ets to_list medium" => fn -> Cbuf.ETS.to_list(ets_filled_medium) end,
  "ets to_list large" => fn -> Cbuf.ETS.to_list(ets_filled_large) end,

  "ets new small" => fn -> Cbuf.ETS.new(small) end,
  "ets new medium" => fn -> Cbuf.ETS.new(medium) end,
  "ets new large" => fn -> Cbuf.ETS.new(large) end,

  "ets peek small" => fn -> Cbuf.ETS.peek(ets_small) end,
  "ets peek medium" => fn -> Cbuf.ETS.peek(ets_medium) end,
  "ets peek large" => fn -> Cbuf.ETS.peek(ets_large) end,

  "ets size small" => fn -> Cbuf.ETS.size(ets_small) end,
  "ets size medium" => fn -> Cbuf.ETS.size(ets_medium) end,
  "ets size large" => fn -> Cbuf.ETS.size(ets_large) end,

  "ets count small" => fn -> Cbuf.ETS.count(ets_small) end,
  "ets count medium" => fn -> Cbuf.ETS.count(ets_medium) end,
  "ets count large" => fn -> Cbuf.ETS.count(ets_large) end,

  "ets delete small" => fn -> Cbuf.ETS.delete(ets_small) end,
  "ets delete medium" => fn -> Cbuf.ETS.delete(ets_medium) end,
  "ets delete large" => fn -> Cbuf.ETS.delete(ets_large) end,

  "ets pop small" => fn -> Cbuf.ETS.pop(ets_small) end,
  "ets pop medium" => fn -> Cbuf.ETS.pop(ets_medium) end,
  "ets pop large" => fn -> Cbuf.ETS.pop(ets_large) end,

  "ets empty? small" => fn -> Cbuf.ETS.empty?(ets_small) end,
  "ets empty? medium" => fn -> Cbuf.ETS.empty?(ets_medium) end,
  "ets empty? large" => fn -> Cbuf.ETS.empty?(ets_large) end,

  "ets member? small" => fn -> Cbuf.ETS.member?(ets_small, 3) end,
  "ets member? medium" => fn -> Cbuf.ETS.member?(ets_medium, 30) end,
  "ets member? large" => fn -> Cbuf.ETS.member?(ets_large, 300) end,

  "queue insert small" => fn -> Cbuf.Queue.insert(queue_small, str) end,
  "queue insert medium" => fn -> Cbuf.Queue.insert(queue_medium, str) end,
  "queue insert large" => fn -> Cbuf.Queue.insert(queue_large, str) end,

  "queue to_list small" => fn -> Cbuf.Queue.to_list(queue_filled_small) end,
  "queue to_list medium" => fn -> Cbuf.Queue.to_list(queue_filled_medium) end,
  "queue to_list large" => fn -> Cbuf.Queue.to_list(queue_filled_large) end,

  "queue new small" => fn -> Cbuf.Queue.new(small) end,
  "queue new medium" => fn -> Cbuf.Queue.new(medium) end,
  "queue new large" => fn -> Cbuf.Queue.new(large) end,

  "queue peek small" => fn -> Cbuf.Queue.peek(queue_small) end,
  "queue peek medium" => fn -> Cbuf.Queue.peek(queue_medium) end,
  "queue peek large" => fn -> Cbuf.Queue.peek(queue_large) end,

  "queue size small" => fn -> Cbuf.Queue.size(queue_small) end,
  "queue size medium" => fn -> Cbuf.Queue.size(queue_medium) end,
  "queue size large" => fn -> Cbuf.Queue.size(queue_large) end,

  "queue count small" => fn -> Cbuf.Queue.count(queue_small) end,
  "queue count medium" => fn -> Cbuf.Queue.count(queue_medium) end,
  "queue count large" => fn -> Cbuf.Queue.count(queue_large) end,

  "queue delete small" => fn -> Cbuf.Queue.delete(queue_small) end,
  "queue delete medium" => fn -> Cbuf.Queue.delete(queue_medium) end,
  "queue delete large" => fn -> Cbuf.Queue.delete(queue_large) end,

  "queue pop small" => fn -> Cbuf.Queue.pop(queue_small) end,
  "queue pop medium" => fn -> Cbuf.Queue.pop(queue_medium) end,
  "queue pop large" => fn -> Cbuf.Queue.pop(queue_large) end,

  "queue empty? small" => fn -> Cbuf.Queue.empty?(queue_small) end,
  "queue empty? medium" => fn -> Cbuf.Queue.empty?(queue_medium) end,
  "queue empty? large" => fn -> Cbuf.Queue.empty?(queue_large) end,

  "queue member? small" => fn -> Cbuf.Queue.member?(queue_small, 3) end,
  "queue member? medium" => fn -> Cbuf.Queue.member?(queue_medium, 300) end,
  "queue member? large" => fn -> Cbuf.Queue.member?(queue_large, 30000) end,
}
Benchee.run(
  benchmarks,
  print: [fast_warning: false],
  time: 5,
  memory_time: 3
)
