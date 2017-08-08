defmodule Talib.EMA do
  @moduledoc ~S"""
  Defines an Exponential Moving Average.

  ## History

  Version: 1.0  
  Source: http://www.itl.nist.gov/div898/handbook/pmc/section3/pmc324.htm  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @typedoc """
  Defines an Exponential Moving Average.

  * :period - The period of the EMA
  * :values - List of values resulting from the calculation
  """
  @type t :: %Talib.EMA{period: integer, values: [float]}
  defstruct [
    period: 0,
    values: []
  ]

  @doc """
  Gets the EMA of a list.

  Returns `{:ok, ema}`, otherwise `{:error, reason}`.

  ## Examples

      iex>Talib.EMA.from_list([1, 2, 3], 2)
      {:ok, %Talib.EMA{period: 2, values: [
        1.0,
        1.6666666666666665,
        2.5555555555555554
      ]}}

      iex>Talib.EMA.from_list([], 2)
      {:error, :no_data}
  """
  @spec from_list([number], integer) :: {:ok, Talib.EMA.t} | {:error, atom}
  def from_list(data, period), do: calculate(data, period)

  @doc """
  Gets the EMA of a list.

  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex>Talib.EMA.from_list!([1, 2, 3], 2)
      %Talib.EMA{period: 2, values: [
        1.0,
        1.6666666666666665,
        2.5555555555555554
      ]}

      iex>Talib.EMA.from_list!([], 2)
      ** (NoDataError) no data error
  """
  @spec from_list!([number], integer) :: Talib.EMA.t | no_return
  def from_list!(data, period) do
    case calculate(data, period) do
      {:ok, result} -> result
      {:error, :no_data} -> raise NoDataError
    end
  end

  @doc false
  @spec calculate([number], integer, [float]) :: {:ok, Talib.EMA.t}
  | {:error, atom}
  defp calculate(data, period, results \\ [])
  defp calculate([], _period, []),
    do: {:error, :no_data}
  defp calculate([], period, results),
    do: {:ok, %Talib.EMA{period: period, values: results}}
  defp calculate([hd | tl], period, []),
    do: calculate(tl, period, [hd / 1])
  defp calculate([hd | tl], period, results) do
    [previous_average] = Enum.take(results, -1)
    new_weight = 2 / (period + 1)
    new_average = hd * new_weight + previous_average * (1 - new_weight)

    calculate(tl, period, results ++ [new_average])
  end
end
