defmodule Suffixes do
  def suffixes(list) when is_list(list) do
    do_suffixes(list, [ ])
  end

  defp do_suffixes([ ], acc), do: Enum.reverse([[ ] | acc])
  defp do_suffixes(list = [_head | tail], acc) do
    do_suffixes(tail, [list | acc])
  end
end
