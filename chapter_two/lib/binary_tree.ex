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
      do_insert(node, new_value, ordering)
    rescue
      DuplicateInsertionError -> IO.inspect(:called); node
    end
  end

  def do_insert(nil, new_value, _ordering), do: %__MODULE__{value: new_value}
  def do_insert(
    node = %__MODULE__{left: left, value: value, right: right},
    new_value,
    ordering
  ) do
    cond do
      ordering.lt(new_value, value) ->
        %__MODULE__{
          left: insert(left, new_value, ordering),
          value: value,
          right: right
        }
      ordering.lt(value, new_value) ->
        %__MODULE__{
          left: left,
          value: value,
          right: insert(right, new_value, ordering)
        }
      true ->
        raise DuplicateInsertionError
    end
  end
end
