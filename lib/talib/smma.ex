defmodule Talib.SMMA do
  alias Talib.SMA

  @moduledoc ~S"""
  Defines a Smoothed Moving Average.

  ## History

  Version: 1.0  
  Source: http://www2.wealth-lab.com/WL5Wiki/SMMA.ashx  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @typedoc """
  Defines a Smoothed Moving Average.

  * :period - The period of the SMMA
  * :values - List of values resulting from the calculation
  """
  @type t :: %Talib.SMMA{period: integer, values: [number]}
  defstruct [
    period: 0,
    values: []
  ]

  @doc """
  Gets the SMMA of a list.

  Returns `{:ok, smma}`, otherwise `{:error, reason}`.

  ## Examples

      iex> Talib.SMMA.from_list([17, 23, 44], 2)
      {:ok, %Talib.SMMA{
        period: 2,
        values: [nil, 20.0, 32.0]
      }}

      iex> Talib.SMMA.from_list([], 1)
      {:error, :no_data}

      iex> Talib.SMMA.from_list([17], 0)
      {:error, :bad_period}
  """
  @spec from_list([number], integer) :: {:ok, Talib.SMMA.t} | {:error, atom}
  def from_list(data, period), do: calculate(data, period)

  @doc """
  Gets the SMMA of a list.

  Raises `NoDataError` if the given list is an empty list.
  Raises `BadPeriodError` if the given period is 0.

  ## Examples

      iex> Talib.SMMA.from_list!([17, 23, 44], 2)
      %Talib.SMMA{
        period: 2,
        values: [nil, 20.0, 32.0]
      }

      iex> Talib.SMMA.from_list!([], 1)
      ** (NoDataError) no data error

      iex> Talib.SMMA.from_list!([17], 0)
      ** (BadPeriodError) bad period error
  """
  @spec from_list!([number], integer) :: Talib.SMMA.t | no_return
  def from_list!(data, period) do
    case calculate(data, period) do
      {:ok, result} -> result
      {:error, :no_data} -> raise NoDataError 
      {:error, :bad_period} -> raise BadPeriodError 
    end
  end

  @doc false
  @spec calculate([number], integer, [float]) :: {:ok, Talib.SMMA.t}
  | {:error, atom}
  defp calculate(data, period, results \\ [])
  defp calculate(data, 0, _results), do: {:error, :bad_period}
  defp calculate(data, period, []) do
    {hd, tl} = Enum.split(data, period)

    case SMA.from_list(hd, period) do
      {:ok, result} ->
        calculate(tl, period, result.values)
      {:error, reason} ->
        {:error, reason}
    end
  end
  defp calculate([], period, results),
    do: {:ok, %Talib.SMMA{period: period, values: results}}
  defp calculate([hd | tl], period, results) do
    [previous_average] = Enum.take(results, -1)
    result = (previous_average * (period - 1) + hd) / period

    calculate(tl, period, results ++ [result])
  end
end
