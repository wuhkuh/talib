# TODO: Moduledocs
defmodule Talib.CMA do
  @moduledoc ~S"""
  Defines a Cumulative Moving Average.

  ## History

  Version: 1.0  
  Source: https://qkdb.wordpress.com/tag/cumulative-moving-average/  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @typedoc """
  Defines a Cumulative Moving Average.

  * :prices - List of prices used in the calculation
  * :values - List of values resulting from the calculation
  * :weight - The current weight of the CMA
  """
  @type t :: %Talib.CMA{prices: [number], values: [number], weight: integer}
  defstruct [
    prices: [],
    values: [],
    weight: 0
  ]

  @doc """
  Gets the CMA of a list.

  Returns `{:ok, cma}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.CMA.from_list([17, 23, 44])
      {:ok, %Talib.CMA{
        prices: [17, 23, 44],
        values: [17.0, 20.0, 28.0],
        weight: 3
      }}

      iex> Talib.CMA.from_list([])
      {:error, :no_data}
  """
  @spec from_list([number]) :: {:ok, Talib.CMA.t} | {:error, atom}
  def from_list(data), do: calculate_cumulative(data)

  @doc """
  Gets the CMA of a list with pre-existing average and weight.

  Returns `{:ok, cma}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.CMA.from_list([17, 23, 44], 1, 3)
      {:ok, %Talib.CMA{
        prices: [1, 17, 23, 44],
        values: [1.0, 5.0, 8.6, 14.5],
        weight: 6
      }}

      iex> Talib.CMA.from_list([], 1, 3)
      {:ok, %Talib.CMA{
        prices: [1],
        values: [1.0],
        weight: 3
      }}

      iex> Talib.CMA.from_list([], 0, 0)
      {:error, :no_data}
  """
  @spec from_list([number], number, integer) ::
  {:ok, Talib.CMA.t}
  | {:error, atom}
  def from_list(average, weight, data),
    do: calculate_cumulative(average, weight, data)

  @doc """
  Gets the cumulative moving average of a list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex> Talib.CMA.from_list!([17, 23, 44])
      %Talib.CMA{
        prices: [17, 23, 44],
        values: [17.0, 20.0, 28.0],
        weight: 3
      }

      iex> Talib.CMA.from_list!([])
      ** (NoDataError) no data error
  """
  @spec from_list!([number]) :: Talib.CMA.t | no_return
  def from_list!(data) do
    case calculate_cumulative(data) do
      {:ok, result} -> result
      {:error, :no_data} -> raise NoDataError 
    end
  end

  @doc """
  Gets the cumulative moving average of a list with pre-existing average and
  weight.

  Raises `NoDataError` if the given list is an empty list and no pre-existing
  average and weight are given.

  ## Examples

      iex> Talib.CMA.from_list!([17, 23, 44], 1, 3)
      %Talib.CMA{
        prices: [1, 17, 23, 44],
        values: [1.0, 5.0, 8.6, 14.5],
        weight: 6
      }

      iex> Talib.CMA.from_list!([], 1, 3)
      %Talib.CMA{
        prices: [1],
        values: [1.0],
        weight: 3
      }

      iex> Talib.CMA.from_list!([], 0, 0)
      ** (NoDataError) no data error
  """
  @spec from_list!([number], number, integer) :: Talib.CMA.t | no_return
  def from_list!(average, weight, data) do
    case calculate_cumulative(average, weight, data) do
      {:ok, result} -> result
      {:error, :no_data} -> raise NoDataError 
    end
  end

################################################################################

  @doc false
  @spec calculate_cumulative([number]) :: {:ok, Talib.CMA.t} | {:error, atom}
  defp calculate_cumulative([]), do: {:error, :no_data}
  defp calculate_cumulative(data), do: calculate_cumulative(data, 0, 0)

  @doc false
  @spec calculate_cumulative([number], number, integer) ::
  {:ok, Talib.CMA.t}
  | {:error, atom}
  defp calculate_cumulative([], _average, 0), do: {:error, :no_data}
  defp calculate_cumulative([], average, weight) do
    {:ok, %Talib.CMA{
      prices: [average],
      values: [average / 1],
      weight: weight
    }}
  end
  defp calculate_cumulative(data, average, weight) do
    result = for {_number, index} <- Enum.with_index(data, 1) do
      Enum.take(data, index)
      |> Enum.sum
      |> Kernel.+(average * weight)
      |> Kernel./(weight + index)
    end

    case weight do
      0 ->
        {:ok, %Talib.CMA{
          prices: data,
          values: result,
          weight: weight + length(data)
        }}
      _ ->
        {:ok, %Talib.CMA{
          prices: [average | data],
          values: [average / 1 | result],
          weight: weight + length(data)
        }}
    end
  end
end
