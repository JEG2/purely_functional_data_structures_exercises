defmodule BinaryTreeTest do
  use ExUnit.Case

  defmodule ComparisonCounter do
    def start_link do
      Agent.start_link(fn -> 0 end, name: __MODULE__)
    end

    def get_count do
      Agent.get(__MODULE__, fn count -> count end)
    end

    def reset do
      Agent.update(__MODULE__, fn _count -> 0 end)
    end

    def lt(left, right) do
      Agent.update(__MODULE__, fn count -> count + 1 end)
      Kernel.<(left, right)
    end

    def eq(left, right) do
      Agent.update(__MODULE__, fn count -> count + 1 end)
      Kernel.==(left, right)
    end
  end

  test "reduce member?() comparisons to depth + 1" do
    root = tree(1..5)
    {:ok, _pid} = ComparisonCounter.start_link

    assert BinaryTree.member?(root, 6, ComparisonCounter) == false
    assert ComparisonCounter.get_count == 6

    ComparisonCounter.reset
    assert BinaryTree.member?(root, 3, ComparisonCounter) == true
    assert ComparisonCounter.get_count == 5
  end

  test "reduce insert() comparisons to depth + 1" do
    root = tree(1..5)
    {:ok, _pid} = ComparisonCounter.start_link

    inserted = BinaryTree.insert(root, 6, ComparisonCounter)
    assert BinaryTree.member?(inserted, 6)
    assert ComparisonCounter.get_count == 6

    ComparisonCounter.reset
    BinaryTree.insert(root, 3, ComparisonCounter)
    assert ComparisonCounter.get_count == 5
  end

  test "complete" do
    root = BinaryTree.complete(42, 5)
    assert to_list(root) == [42, 42, 42, 42, 42]
  end

  defp tree(enum) do
    Enum.reduce(enum, BinaryTree.empty, fn value, node ->
      BinaryTree.insert(node, value)
    end)
  end

  defp to_list(nil), do: [ ]
  defp to_list(node) do
    to_list(node.left) ++ [node.value] ++ to_list(node.right)
  end
end
