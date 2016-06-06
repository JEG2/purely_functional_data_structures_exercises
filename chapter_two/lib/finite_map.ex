defmodule FiniteMap do
  defstruct left: nil, key: nil, value: nil, right: nil

  defmodule NotFoundError do
    defexception [:message]
  end

  def new, do: nil

  def bind(nil, new_key, new_value) do
    %__MODULE__{key: new_key, value: new_value}
  end
  def bind(
    map = %__MODULE__{left: left, key: key, right: right},
    new_key,
    new_value
  ) do
    cond do
      new_key < key ->
        %__MODULE__{map | left: bind(left, new_key, new_value)}
      new_key > key ->
        %__MODULE__{map | right: bind(right, new_key, new_value)}
      true ->
        %__MODULE__{map | value: new_value}
    end
  end

  def lookup(nil, test_key) do
    raise NotFoundError, message: "`#{test_key}` not found"
  end
  def lookup(
    %__MODULE__{left: left, key: key, value: value, right: right},
    test_key
  ) do
    cond do
      test_key < key -> lookup(left, test_key)
      test_key > key -> lookup(right, test_key)
      true -> value
    end
  end
end
