defmodule Talib.Average do
  alias Talib.Utility

  @moduledoc ~S"""
  Module containing average functions, such as the mean,
  mode and median.
  """

  @doc """
  Gets the mean of a list.

  Returns `{:ok, mean}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Average.mean([1, 2, 3, 4])
      {:ok, 2.5}

      iex> Talib.Average.mean([1])
      {:ok, 1.0}

      iex> Talib.Average.mean([])
      {:error, :no_data}

  ## History

  Version: 1.0  
  Source: http://mathworld.wolfram.com/ArithmeticMean.html  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec mean([number]) :: {:ok, number} | {:error, atom}
  def mean([]), do: {:error, :no_data}
  def mean(data), do: {:ok, Enum.sum(data) / length(data)}

  @doc """
  Gets the median of a list.

  Returns `{:ok, median}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Average.median([1, 2, 3, 4, 5])
      {:ok, 3.0}

      iex> Talib.Average.median([1, 2, 3, 4])
      {:ok, 2.5}

      iex> Talib.Average.median([1])
      {:ok, 1.0}

      iex> Talib.Average.median([])
      {:error, :no_data}

  ## History

  Version: 1.0  
  Source: http://mathworld.wolfram.com/StatisticalMedian.html  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec median([number]) :: {:ok, number} | {:error, atom}
  def median([]), do: {:error, :no_data}
  def median(data) do
    midpoint = data
    |> length
    |> Integer.floor_div(2)

    # 0 is even, 1 is odd
    case data |> length |> rem(2) do
      0 ->
        {_, [med1, med2 | _]} = Enum.split(data, midpoint - 1)
        {:ok, (med1 + med2) / 2}
      1 ->
        {_, [median | _]} = Enum.split(data, midpoint)
        {:ok, median / 1}
    end
  end

  @doc """
  Gets the midrange of a list.

  Returns `{:ok, midrange}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Average.midrange([1, 2, 3, 4, 5])
      {:ok, 3.0}

      iex> Talib.Average.midrange([1, 2, 3, 4])
      {:ok, 2.5}

      iex> Talib.Average.midrange([1])
      {:ok, 1.0}

      iex> Talib.Average.midrange([])
      {:error, :no_data}

  ## History

  Version: 1.0  
  Source: http://mathworld.wolfram.com/Midrange.html  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec midrange([number]) :: {:ok, number} | {:error, atom}
  def midrange([]), do: {:error, :no_data}
  def midrange(data) do
    max = data |> Enum.max
    min = data |> Enum.min

    {:ok, (max + min) / 2}
  end

  @doc """
  Gets the most frequently occuring value in a list.

  Returns `{:ok, mode}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.Average.mode([1, 2, 3, 4, 5])
      {:ok, [1, 2, 3, 4, 5]}

      iex> Talib.Average.mode([1, 2, 3, 4, 2])
      {:ok, 2}

      iex> Talib.Average.mode([1])
      {:ok, 1}

      iex> Talib.Average.mode([])
      {:error, :no_data}

  ## History

  Version: 1.0  
  Source: http://mathworld.wolfram.com/Mode.html  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec mode([number]) :: {:ok, [number, ...] | number} | {:error, atom}
  def mode([]), do: {:error, :no_data}
  def mode(data) do
    case Utility.occur(data) do
      {:ok, occur} -> {:ok, map_max(occur)}
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Gets the mean of a list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex> Talib.Average.mean!([1, 2, 3, 4])
      2.5

      iex> Talib.Average.mean!([1])
      1.0

      iex> Talib.Average.mean!([])
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Source: http://mathworld.wolfram.com/ArithmeticMean.html  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec mean!([number]) :: number | no_return
  def mean!([]), do: raise NoDataError
  def mean!(data), do: Enum.sum(data) / length(data)

  @doc """
  Gets the median of a list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex> Talib.Average.median!([1, 2, 3, 4, 5])
      3.0

      iex> Talib.Average.median!([1, 2, 3, 4])
      2.5

      iex> Talib.Average.median!([1])
      1.0

      iex> Talib.Average.median!([])
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Source: http://mathworld.wolfram.com/StatisticalMedian.html  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec median!([number]) :: number | no_return
  def median!([]), do: raise NoDataError
  def median!(data) do
    midpoint = data
    |> length
    |> Integer.floor_div(2)

    # 0 is even, 1 is odd
    case data |> length |> rem(2) do
      0 ->
        {_, [med1, med2 | _]} = Enum.split(data, midpoint - 1)
        (med1 + med2) / 2
      1 ->
        {_, [median | _]} = Enum.split(data, midpoint)
        median / 1
    end
  end

  @doc """
  Gets the midrange of a list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex> Talib.Average.midrange!([1, 2, 3, 4, 5])
      3.0

      iex> Talib.Average.midrange!([1, 2, 3, 4])
      2.5

      iex> Talib.Average.midrange!([1])
      1.0

      iex> Talib.Average.midrange!([])
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Source: http://mathworld.wolfram.com/Midrange.html  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec midrange!([number]) :: number | no_return
  def midrange!([]), do: raise NoDataError
  def midrange!(data) do
    max = data |> Enum.max
    min = data |> Enum.min

    (max + min) / 2
  end

  @doc """
  Gets the most frequently occuring value in a list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex> Talib.Average.mode!([1, 2, 3, 4, 5])
      [1, 2, 3, 4, 5]

      iex> Talib.Average.mode!([1, 2, 3, 4, 2])
      2

      iex> Talib.Average.mode!([1])
      1

      iex> Talib.Average.mode!([])
      ** (NoDataError) no data error

  ## History

  Version: 1.0  
  Source: http://mathworld.wolfram.com/Mode.html  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """
  @spec mode!([number]) :: [number, ...] | number | no_return
  def mode!([]), do: raise NoDataError
  def mode!(data) do
    data
    |> Utility.occur!
    |> map_max
  end

  @doc false
  @spec deviation!([number]) :: [number, ...] | number | no_return
  def deviation!([]), do: raise NoDataError
  def deviation!(data) do
    m = data
    |> mean!

    l = length(data)
    
    data
    |> Enum.reduce(0, fn(x, acc) -> :math.pow(x - m, 2) + acc end)
    |> Kernel./(l)
    |> :math.sqrt()

  end

  defp deviation_reduce(data, mean) do
    l = length(data)
    data
    |> Enum.reduce(0, fn(x, acc) -> :math.pow(x - mean, 2) + acc end)
    |> Kernel./(l)
    |> :math.sqrt()
  end

  @doc false
  @spec deviation([number]) :: [number, ...] | number | {:error, atom}
  def deviation([]), do: {:error, :no_data}
  def deviation(data) do
    case data |> mean do
      {:ok, mean} -> deviation_reduce(data, mean)
      {:error, reason} -> {:error, reason}
    end
  end



  @doc false
  @spec map_max(map()) :: number | [number, ...]
  defp map_max(map) do
    max = map
    |> Map.values
    |> Enum.max

    # Create array of maximums
    # Add key to maximums array
    maxes = Enum.reduce(map, [], fn({key, value}, acc) ->
      case value do
        ^max -> [key | acc]
        _ -> acc
      end
    end)

    # Support multiple maximums %{a: 3, b: 3} => [:a, :b]
    # Or single maximum %{a: 3, b: 2} => [:a]
    case maxes do
      [n] -> n
      [_ | _] = array -> Enum.reverse(array)
    end
  end
end
