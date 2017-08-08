defmodule Talib.Utility do
  @moduledoc ~S"""
  Module containing utility functions, used in the
  calculation of indicators and oscillators.
  """

  @doc """
  Gets the change in the list.
  
  The `direction` parameter is a direction filter, which defaults to 0.
  Returns `{:ok, change}`, otherwise `{:error, reason}`.

  If 0, it keeps track of both gains and losses.
  If 1, it replaces losses with a 0. Results are absolute values.
  If -1, it replaces gains with a 0. Results are absolute values.

  ## Examples

      iex> Talib.Utility.change([1, 2, -3])
      {:ok, [nil, 1, -5]}

      iex> Talib.Utility.change([1, 2, -3], 1)
      {:ok, [nil, 1, 0]}

      iex> Talib.Utility.change([1, 2, -3], -1)
      {:ok, [nil, 0, 5]}

      iex> Talib.Utility.change([1], -1)
      {:ok, [nil]}

      iex> Talib.Utility.change([], -1)
      {:error, :no_data}

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec change([number], integer) :: {:ok, [number, ...]} | {:error, atom}
  def change(_data, direction \\ 0)
  def change([], _direction), do: {:error, :no_data}
  def change(data, direction) do
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

    {:ok, [nil | result]}
  end

  @doc """
  Gets the gain in the list.

  Alias for `MovingAverage.change(data, 1)`.
  Returns `{:ok, gain}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Utility.gain([1, 2, -3])
      {:ok, [nil, 1, 0]}

      iex> Talib.Utility.gain([1])
      {:ok, [nil]}

      iex> Talib.Utility.gain([])
      {:error, :no_data}

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec gain([number]) :: {:ok, [number, ...]} | {:error, atom}
  def gain(data), do: change(data, 1)

  @doc """
  Gets the highest number in the list.

  Returns `{:ok, high}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Utility.high([1])
      {:ok, 1}

      iex> Talib.Utility.high([1, 3])
      {:ok, 3}

      iex> Talib.Utility.high([])
      {:error, :no_data}

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec high([number]) :: {:ok, number} | {:error, atom}
  def high([]), do: {:error, :no_data}
  def high(data), do: {:ok, Enum.max(data)}

  @doc """
  Gets the loss in the list.

  Alias for `MovingAverage.change(data, -1)`.
  Returns `{:ok, loss}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Utility.loss([1, 2, -3])
      {:ok, [nil, 0, 5]}

      iex> Talib.Utility.loss([1])
      {:ok, [nil]}

      iex> Talib.Utility.loss([])
      {:error, :no_data}

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec loss([number]) :: {:ok, [number, ...]} | {:error, atom}
  def loss(data), do: change(data, -1)

  @doc """
  Gets the lowest number in the list.

  Returns `{:ok, low}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Utility.low([1])
      {:ok, 1}

      iex> Talib.Utility.low([1, 3])
      {:ok, 1}

      iex> Talib.Utility.low([])
      {:error, :no_data}

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec low([number]) :: {:ok, number} | {:error, atom}
  def low([]), do: {:error, :no_data}
  def low(data), do: {:ok, Enum.min(data)}

  @doc """
  Creates a map with the amount of times each element of a
  list is present in the list.

  Returns `{:ok, occur}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Utility.occur([1, 2, 3])
      {:ok, %{1 => 1, 2 => 1, 3 => 1}}

      iex> Talib.Utility.occur([1, 2, 3, 2])
      {:ok, %{1 => 1, 2 => 2, 3 => 1}}

      iex> Talib.Utility.occur([])
      {:error, :no_data}

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec occur([number]) :: {:ok, map} | {:error, atom}
  def occur([]), do: {:error, :no_data}
  def occur(data) do
    result = Enum.reduce(data, %{}, fn(tag, acc) ->
      Map.update(acc, tag, 1, &(&1 + 1))
    end)
    
    {:ok, result}
  end

  @doc """
  Gets the change in the list.

  The `direction` parameter is a direction filter, which defaults to 0.

  If 0, it keeps track of both gains and losses.
  If 1, it replaces losses with a 0. Results are absolute values.
  If -1, it replaces gains with a 0. Results are absolute values.

  Raises `NoDataError` if the given list is an empty list.
  Raises `InsufficientDataError` if the given list only has one element.

  ## Examples

      iex> Talib.Utility.change!([1, 2, -3])
      [nil, 1, -5]

      iex> Talib.Utility.change!([1, 2, -3], 1)
      [nil, 1, 0]

      iex> Talib.Utility.change!([1, 2, -3], -1)
      [nil, 0, 5]

      iex> Talib.Utility.change!([1], -1)
      [nil]

      iex> Talib.Utility.change!([], -1)
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec change!([number], integer) :: [number, ...] | no_return
  def change!(_data, direction \\ 0)
  def change!([], _direction), do: raise NoDataError
  def change!(data, direction) do
    {:ok, result} = change(data, direction)

    result
  end

  @doc """
  Gets the gain in the list.

  Alias for `MovingAverage.change!(data, 1)`.
  Raises `NoDataError` if the given list is an empty list.
  Raises `InsufficientDataError` if the given list only has one element.

  ## Examples

      iex> Talib.Utility.gain!([1, 2, -3])
      [nil, 1, 0]

      iex> Talib.Utility.gain!([1])
      [nil]

      iex> Talib.Utility.gain!([])
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec gain!([number]) :: [number, ...] | no_return
  def gain!(data), do: change!(data, 1)

  @doc """
  Gets the highest number in the list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex> Talib.Utility.high!([1])
      1

      iex> Talib.Utility.high!([1, 3])
      3

      iex> Talib.Utility.high!([])
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec high!([number]) :: number | no_return
  def high!([]), do: raise %NoDataError{}
  def high!(data), do: Enum.max(data)

  @doc """
  Gets the loss in the list.

  Alias for `MovingAverage.change!(data, -1)`.
  Raises `NoDataError` if the given list is an empty list.
  Raises `InsufficientDataError` if the given list only has one element.

  ## Examples

      iex> Talib.Utility.loss!([1, 2, -3])
      [nil, 0, 5]

      iex> Talib.Utility.loss!([1])
      [nil]

      iex> Talib.Utility.loss!([])
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec loss!([number]) :: [number, ...] | no_return
  def loss!(data), do: change!(data, -1)

  @doc """
  Gets the lowest number in the list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex> Talib.Utility.low!([1])
      1

      iex> Talib.Utility.low!([1, 3])
      1

      iex> Talib.Utility.low!([])
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec low!([number]) :: number | no_return
  def low!([]), do: raise %NoDataError{}
  def low!(data), do: Enum.min(data)

  @doc """
  Creates a map with the amount of times each element of a
  list is present in the list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex> Talib.Utility.occur!([1, 2, 3])
      %{1 => 1, 2 => 1, 3 => 1}

      iex> Talib.Utility.occur!([1, 2, 3, 2])
      %{1 => 1, 2 => 2, 3 => 1}

      iex> Talib.Utility.occur!([])
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec occur!([number]) :: map | no_return
  def occur!([]), do: raise %NoDataError{}
  def occur!(data) do
    Enum.reduce(data, %{}, fn(tag, acc) ->
      Map.update(acc, tag, 1, &(&1 + 1))
    end)
  end
end
