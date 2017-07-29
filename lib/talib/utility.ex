defmodule Talib.Utility do
  @moduledoc ~S"""
  Module containing utility functions, used in the calculation of indicators and oscillators.
  """

  @doc """
  Gets the highest number in the list.
  """
  def high([]), do: nil
  def high(list) when is_list(list), do: Enum.max(list)

  @doc """
  Gets the lowest number in the list.
  """
  def low([]), do: nil
  def low(list) when is_list(list), do: Enum.min(list)

  @doc """
  Gets the gain in the list.
  """
  def gain([]), do: nil
  def gain(list) when is_list(list), do: change(list, 1)

  @doc """
  Gets the loss in the list.
  """
  def loss([]), do: nil
  def loss(list) when is_list(list), do: change(list, -1)

  @doc """
  Gets the change in the list.
  """
  def change([]), do: nil
  def change(list, direction \\ 0) do
    [_, result] = Enum.reduce(list, [nil, []], fn(element, acc) ->
      [last_element, total] = acc
  
      cond do
        (last_element === nil) ->
          [element, total]
        ((direction === 1 && element - last_element > 0) ||
        (direction === -1 && element - last_element < 0)) ->
          [element, total ++ [abs(element - last_element)]]
        (direction === 0) ->
          [element, total ++ [element - last_element]]
        true ->
          [element, total ++ [0]]
      end
    end)

    result
  end

  @doc """
  Creates a map with the amount of times each element of list is present in the list.
  """
  def occur([]), do: nil
  def occur(list) when is_list(list) do
    Enum.reduce(list, %{}, fn(tag, acc) -> Map.update(acc, tag, 1, &(&1 + 1)) end)
  end
end
