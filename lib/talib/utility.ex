defmodule Talib.Utility do
  @moduledoc ~S"""
  Utility functions that are used in the calculation of indicators and oscillators.
  """

  @doc """
  Gets the highest number in the list.
  """
  def high(list) when is_list(list), do: Enum.max(list)
  def high(number) when is_number(number), do: number

  @doc """
  Gets the lowest number in the list.
  """
  def low(list) when is_list(list), do: Enum.min(list)
  def low(number) when is_number(number), do: number

  @doc """
  Gets the gain in the list.
  """
  def gain(list) when is_list(list), do: change(list, 1)
  def gain(number) when is_number(number), do: number

  @doc """
  Gets the loss in the list.
  """
  def loss(list) when is_list(list), do: change(list, -1)
  def loss(number) when is_number(number), do: number

  @doc """
  Gets the change in the list.
  """
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
end