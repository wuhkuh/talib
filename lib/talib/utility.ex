defmodule Talib.Utility do
  @moduledoc ~S"""
  Module containing utility functions, used in the
  calculation of indicators and oscillators.
  """

  @doc """
  Gets the highest number in the list.
  """
  @spec high([integer] | [float]) :: integer | float
  def high([]), do: nil
  def high([n]), do: n
  def high([_ | _] = list), do: Enum.max(list)

  @doc """
  Gets the lowest number in the list.
  """
  @spec low([integer] | [float]) :: integer | float
  def low([]), do: nil
  def low([n]), do: n
  def low([_ | _] = list), do: Enum.min(list)

  @doc """
  Gets the gain in the list.
  """
  @spec gain([integer] | [float]) :: integer | float
  def gain([]), do: nil
  def gain([_]), do: nil
  def gain([_ | _] = list), do: change(list, 1)

  @doc """
  Gets the loss in the list.
  """
  @spec loss([integer] | [float]) :: integer | float
  def loss([]), do: nil
  def loss([_]), do: nil
  def loss([_ | _] = list), do: change(list, -1)

  @doc """
  Gets the change in the list.
  """
  @spec change([integer] | [float]) :: integer | float
  def change([]), do: nil
  def change([_]), do: nil
  def change(list, direction \\ 0) do
    [_, result] = Enum.reduce(list, [nil, []], fn(element, [last_el, total]) ->
  
      # Check differences between last element and current element
      cond do
        (last_el === nil) ->
          [element, total]
        ((direction === 1 && element - last_el > 0) ||
        (direction === -1 && element - last_el < 0)) ->
          [element, total ++ [abs(element - last_el)]]
        (direction === 0) ->
          [element, total ++ [element - last_el]]
        true ->
          [element, total ++ [0]]
      end
    end)

    result
  end

  @doc """
  Creates a map with the amount of times each element of list is present in the list.
  """
  @spec occur([integer] | [float]) :: map()
  def occur([]), do: nil
  def occur([n]), do: %{n => 1}
  def occur([_ | _] = list) do
    Enum.reduce(list, %{}, fn(tag, acc) -> Map.update(acc, tag, 1, &(&1 + 1)) end)
  end
end
