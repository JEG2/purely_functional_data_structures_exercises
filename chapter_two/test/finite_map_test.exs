defmodule FiniteMapTest do
  use ExUnit.Case

  test "binding and lookup" do
    map = FiniteMap.new
    assert_raise(
      FiniteMap.NotFoundError,
      fn -> FiniteMap.lookup(map, :missing) end
    )

    map = FiniteMap.bind(map, :a, 1)
    map = FiniteMap.bind(map, :b, 2)
    map = FiniteMap.bind(map, :b, 3)
    assert FiniteMap.lookup(map, :a) == 1
    assert FiniteMap.lookup(map, :b) == 3
    assert_raise(
      FiniteMap.NotFoundError,
      fn -> FiniteMap.lookup(map, :missing) end
    )
  end
end
