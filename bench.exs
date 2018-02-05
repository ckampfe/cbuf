small = Cbuf.new(5)
medium = Cbuf.new(50)
large = Cbuf.new(500)
xlarge = Cbuf.new(5000)

str = "ok"

filled_small = Enum.reduce(1..5, small, fn(val, buf) -> Cbuf.insert(buf, val) end)
filled_medium = Enum.reduce(1..50, medium, fn(val, buf) -> Cbuf.insert(buf, val) end)
filled_large = Enum.reduce(1..500, large, fn(val, buf) -> Cbuf.insert(buf, val) end)
filled_xlarge = Enum.reduce(1..5000, xlarge, fn(val, buf) -> Cbuf.insert(buf, val) end)


Benchee.run(%{
  "insert small" => fn -> Cbuf.insert(small, str) end,
  "insert medium" => fn -> Cbuf.insert(medium, str) end,
  "insert large" => fn -> Cbuf.insert(large, str) end,
  "insert xlarge" => fn -> Cbuf.insert(xlarge, str) end,

  "to_list small" => fn -> Cbuf.to_list(filled_small) end,
  "to_list medium" => fn -> Cbuf.to_list(filled_medium) end,
  "to_list large" => fn -> Cbuf.to_list(filled_large) end,
  "to_list xlarge" => fn -> Cbuf.to_list(filled_xlarge) end,

  "new small" => fn -> Cbuf.new(5) end,
  "new medium" => fn -> Cbuf.new(50) end,
  "new large" => fn -> Cbuf.new(500) end,
  "new xlarge" => fn -> Cbuf.new(5000) end,

  # just to prove that these are all constant time operations
  "peek small" => fn -> Cbuf.peek(small) end,
  "peek medium" => fn -> Cbuf.peek(medium) end,
  "peek large" => fn -> Cbuf.peek(large) end,
  "peek xlarge" => fn -> Cbuf.peek(xlarge) end,

  # just to prove that these are all constant time operations
  "size small" => fn -> Cbuf.size(small) end,
  "size medium" => fn -> Cbuf.size(medium) end,
  "size large" => fn -> Cbuf.size(large) end,
  "size xlarge" => fn -> Cbuf.size(xlarge) end,

  "count small" => fn -> Cbuf.count(small) end,
  "count medium" => fn -> Cbuf.count(medium) end,
  "count large" => fn -> Cbuf.count(large) end,
  "count xlarge" => fn -> Cbuf.count(xlarge) end,

  "delete small" => fn -> Cbuf.delete(small) end,
  "delete medium" => fn -> Cbuf.delete(medium) end,
  "delete large" => fn -> Cbuf.delete(large) end,
  "delete xlarge" => fn -> Cbuf.delete(xlarge) end,

  "pop small" => fn -> Cbuf.pop(small) end,
  "pop medium" => fn -> Cbuf.pop(medium) end,
  "pop large" => fn -> Cbuf.pop(large) end,
  "pop xlarge" => fn -> Cbuf.pop(xlarge) end,
}, print: [fast_warning: false])
