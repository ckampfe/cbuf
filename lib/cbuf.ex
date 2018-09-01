defmodule Cbuf do
  @moduledoc """
  This module describes the behavior of a [circular buffer](https://en.wikipedia.org/wiki/Circular_buffer).

  A circular buffer is useful if you care about newer data more than older data.
  Examples might include applications where you want to process the most recent events without having to process older ones,
  or where you wish to compute statistics over only the newest events in a stream.

  This library provides three implementations of `Cbuf`: `Cbuf.Queue`, `Cbuf.Map`, and `Cbuf.ETS`.
  I recommend defaulting to `Cbuf.Queue` unless you specifically know that `Cbuf.Map` or `Cbuf.ETS` will
  better serve your use case.

  This version of the structure operates on a First In, First Out basis, where the "first" value out of the structure is the oldest,
  and every value after that will be newer, with the last item in the buffer being the newest.

  """

  @opaque t :: Cbuf.Map.t() | Cbuf.ETS.t() | Cbuf.Queue.t()

  @callback new(pos_integer) :: t
  @callback size(t) :: non_neg_integer
  @callback empty?(t) :: boolean
  @callback insert(t, term) :: t
  @callback peek(t) :: term | nil
  @callback pop(t) :: {term | nil, t}
  @callback delete(t) :: t
  @callback to_list(t) :: [term] | []
  @callback count(t) :: non_neg_integer
  @callback member?(t, term) :: boolean
end
