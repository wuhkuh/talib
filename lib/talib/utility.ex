defmodule Talib.Utility do
  @moduledoc ~S"""
  Module containing utility functions, used in the
  calculation of indicators and oscillators.
  """

  @doc """
  Gets the change in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec change([number], integer) :: [number, ...] | number | nil
  def change([]), do: nil
  def change([_]), do: nil
  def change(data, direction \\ 0) when is_list(data) do
    [_, result] = Enum.reduce(data, [nil, []], fn(element, [last_el, total]) ->

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
  Gets the gain in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec gain([number]) :: [number, ...] | number | nil
  def gain([]), do: nil
  def gain([_]), do: nil
  def gain(data) when is_list(data), do: change(data, 1)

  @doc """
  Gets the highest number in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec high([number]) :: number | nil
  def high([]), do: nil
  def high([n]), do: n
  def high(data) when is_list(data), do: Enum.max(data)

  @doc """
  Gets the loss in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec loss([number]) :: [number, ...] | number | nil
  def loss([]), do: nil
  def loss([_]), do: nil
  def loss(data) when is_list(data), do: change(data, -1)

  @doc """
  Gets the lowest number in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec low([number]) :: number | nil
  def low([]), do: nil
  def low([n]), do: n
  def low(data) when is_list(data), do: Enum.min(data)

  @doc """
  Creates a map with the amount of times each element of a
  list is present in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec occur([number]) :: map() | nil
  def occur([]), do: nil
  def occur([n]), do: %{n => 1}
  def occur(data) when is_list(data) do
    Enum.reduce(data, %{}, fn(tag, acc) ->
      Map.update(acc, tag, 1, &(&1 + 1))
    end)
  end
end
