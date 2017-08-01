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

  @spec change([]) :: number | nil
  @spec change([number, ...]) :: [number] | nil
  @spec change([number, ...], integer) :: [number]
  def change([]), do: nil
  def change([_]), do: nil
  def change(list, direction \\ 0) when is_list(list) do
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
  Gets the gain in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec gain([]) :: number | nil
  @spec gain([number, ...]) :: [number] | nil
  def gain([]), do: nil
  def gain([_]), do: nil
  def gain(list) when is_list(list), do: change(list, 1)

  @doc """
  Gets the highest number in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec high([]) :: nil
  @spec high([number, ...]) :: number
  def high([]), do: nil
  def high([n]), do: n
  def high(list) when is_list(list), do: Enum.max(list)

  @doc """
  Gets the loss in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec loss([]) :: number | nil
  @spec loss([number, ...]) :: [number] | nil
  def loss([]), do: nil
  def loss([_]), do: nil
  def loss(list) when is_list(list), do: change(list, -1)

  @doc """
  Gets the lowest number in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec low([]) :: nil
  @spec low([number, ...]) :: number
  def low([]), do: nil
  def low([n]), do: n
  def low(list) when is_list(list), do: Enum.min(list)

  @doc """
  Creates a map with the amount of times each element of
  list is present in the list.

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec occur([]) :: nil
  @spec occur([number, ...]) :: map()
  def occur([]), do: nil
  def occur([n]), do: %{n => 1}
  def occur(list) when is_list(list) do
    Enum.reduce(list, %{}, fn(tag, acc) ->
      Map.update(acc, tag, 1, &(&1 + 1))
    end)
  end
end
