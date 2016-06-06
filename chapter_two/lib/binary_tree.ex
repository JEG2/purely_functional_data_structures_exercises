defmodule BinaryTree do
  defstruct left: nil, value: nil, right: nil

  defmodule Comparisons do
    def eq(left, right), do: Kernel.==(left, right)
    def lt(left, right), do: Kernel.<(left, right)
  end

  defmodule DuplicateInsertionError do
    defexception message: "Member is already in tree"
  end

  def empty, do: nil

  def member?(node, test_value, ordering \\ Comparisons, candidate \\ nil)
  def member?(nil, test_value, ordering, candidate) do
    ordering.eq(test_value, candidate)
  end
  def member?(
    %__MODULE__{left: left, value: value, right: right},
    test_value,
    ordering,
    candidate
  ) do
    if ordering.lt(test_value, value) do
      member?(left, test_value, ordering, candidate)
    else
      member?(right, test_value, ordering, value)
    end
  end

  def insert(node, new_value, ordering \\ Comparisons) do
    try do
      do_insert(node, new_value, ordering, nil)
    rescue
      DuplicateInsertionError -> node
    end
  end

  defp do_insert(nil, new_value, ordering, candidate) do
    if ordering.eq(candidate, new_value) do
      raise DuplicateInsertionError
    else
      %__MODULE__{value: new_value}
    end
  end
  defp do_insert(
    %__MODULE__{left: left, value: value, right: right},
    new_value,
    ordering,
    candidate
  ) do
    if ordering.lt(new_value, value) do
      %__MODULE__{
        left: do_insert(left, new_value, ordering, candidate),
        value: value,
        right: right
      }
    else
      %__MODULE__{
        left: left,
        value: value,
        right: do_insert(right, new_value, ordering, value)
      }
    end
  end

  def complete(value, depth), do: do_complete(value, depth)

  defp do_complete(_value, 0), do: nil
  defp do_complete(value, depth) do
    left_depth = div(depth - 1, 2)
    right_depth = depth - 1 - left_depth
    left = do_complete(value, left_depth)
    right =
      if left_depth == right_depth do
        left
      else
        do_complete(value, right_depth)
      end
    %__MODULE__{left: left, value: value, right: right}
  end
end
