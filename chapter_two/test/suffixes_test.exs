defmodule SuffixesTest do
  use ExUnit.Case

  test "lists all suffixes" do
    actual = Suffixes.suffixes([1, 2, 3, 4])
    expected = [[1, 2, 3, 4], [2, 3, 4], [3, 4], [4], [ ]]
    assert actual == expected
  end
end
