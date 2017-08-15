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

      iex> Talib.Utility.change([1, 2, nil, -3], 0)
      {:ok, [nil, 1, nil, nil]}

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
        (element === nil or last_el === nil) ->
          [element, total ++ [nil]]
        ((direction === 1 and element - last_el > 0) or
        (direction === -1 and element - last_el < 0)) ->
          [element, total ++ [abs(element - last_el)]]
        (direction === 0) ->
          [element, total ++ [element - last_el]]
        true ->
          [element, total ++ [0]]
      end
    end)

    {:ok, result}
  end

  @doc """
  Gets the gain in the list.

  Returns `{:ok, gain}`, otherwise `{:error, reason}`.

  Alias for `Talib.Utility.change(data, 1)`.

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

      iex> Talib.Utility.high([1, nil, 3])
      {:ok, 3}

      iex> Talib.Utility.high([nil])
      {:ok, nil}

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
  def high(data) do
    filtered_data = filter_nil(data)
    highest = case filtered_data do
      [] -> nil
      [_ | _] -> Enum.max(filtered_data)
    end
    {:ok, highest}
  end

  @doc """
  Gets the loss in the list.

  Returns `{:ok, loss}`, otherwise `{:error, reason}`.

  Alias for `Talib.Utility.change(data, -1)`.

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

      iex> Talib.Utility.low([1, nil, 3])
      {:ok, 1}

      iex> Talib.Utility.low([nil])
      {:ok, nil}

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
  def low(data) do
    filtered_data = filter_nil(data)
    lowest = case filtered_data do
      [] -> nil
      [_ | _] -> Enum.min(filtered_data)
    end

    {:ok, lowest}
  end

  @doc """
  Creates a map with the amount of times each element of a
  list is present in the list.

  Returns `{:ok, occur}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Utility.occur([1, 2, 3])
      {:ok, %{1 => 1, 2 => 1, 3 => 1}}

      iex> Talib.Utility.occur([1, 2, 3, 2])
      {:ok, %{1 => 1, 2 => 2, 3 => 1}}

      iex> Talib.Utility.occur([1, 2, nil, 3, 2])
      {:ok, %{1 => 1, 2 => 2, 3 => 1, nil => 1}}

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

  ## Examples

      iex> Talib.Utility.change!([1, 2, -3])
      [nil, 1, -5]

      iex> Talib.Utility.change!([1, 2, -3], 1)
      [nil, 1, 0]

      iex> Talib.Utility.change!([1, 2, nil, -3], 0)
      [nil, 1, nil, nil]

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
  def change!(data, direction \\ 0)
  def change!(data, direction), do: data |> change(direction) |> to_bang_function

  @doc """
  Gets the gain in the list.

  Raises `NoDataError` if the given list is an empty list.

  Alias for `Talib.Utility.change!(data, 1)`.

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

      iex> Talib.Utility.high!([1, nil, 3])
      3

      iex> Talib.Utility.high!([nil])
      nil

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
  def high!(data), do: data |> high |> to_bang_function

  @doc """
  Gets the loss in the list.

  Raises `NoDataError` if the given list is an empty list.

  Alias for `Talib.Utility.change!(data, -1)`.

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

      iex> Talib.Utility.low!([1, nil, 3])
      1

      iex> Talib.Utility.low!([nil])
      nil

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
  def low!(data), do: data |> low |> to_bang_function

  @doc """
  Creates a map with the amount of times each element of a
  list is present in the list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex> Talib.Utility.occur!([1, 2, 3])
      %{1 => 1, 2 => 1, 3 => 1}

      iex> Talib.Utility.occur!([1, 2, 3, 2])
      %{1 => 1, 2 => 2, 3 => 1}

      iex> Talib.Utility.occur!([nil, 1, 2, 3, 2])
      %{1 => 1, 2 => 2, 3 => 1, nil => 1}

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
  def occur!(data), do: data |> occur |> to_bang_function

  @doc """
  Filters nil from the input list.

  ## Examples

    iex> Talib.Utility.filter_nil([1, 2, 3, nil, 5])
    [1, 2, 3, 5]

  """
  @spec filter_nil([number | nil]) :: [number]
  def filter_nil(data), do: Enum.filter(data, &(&1 !== nil))


  @doc """
  Transforms an input function to a bang function, which either returns the
  output value or raises errors.

  ## Examples

    iex> Talib.Utility.to_bang_function({:ok, [1, 2, 3, nil, 5]})
    [1, 2, 3, nil, 5]

    iex> Talib.Utility.to_bang_function({:error, :bad_period})
    ** (BadPeriodError) bad period error

    iex> Talib.Utility.to_bang_function({:error, :no_data})
    ** (NoDataError) no data error

  """
  @spec to_bang_function({atom, any | atom}) :: any | no_return
  def to_bang_function({:ok, result}), do: result
  def to_bang_function({:error, error}) do
    case error do
      :bad_period -> raise BadPeriodError
      :no_data -> raise NoDataError
    end
  end
end
