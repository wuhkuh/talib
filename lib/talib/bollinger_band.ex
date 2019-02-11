defmodule Talib.BollingerBand do
  alias Talib.SMA
  alias Talib.Average
  require OK
  require Logger

  @moduledoc ~S"""
  Defines a Bollinger bands.

  ## History

  Version: 1.0  
  https://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:bollinger_bands 
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @typedoc """
  Defines a Bollinger Band price volatility.
  * :period - Period used to calculate SMA, typically 20
  * :deviation - Multiplier to standard deviation from SMA typically 2
  * :values - List of values resulting from the calculation {upper, middle, lower}
  """
  @type t :: %Talib.BollingerBand{
    period: integer,
    deviation: integer,
    values: [number]
  }

  defstruct [
    period: 0,
    deviation: 0,
    values: [],
  ]

  @doc """
  Gets the BBand of a list.

  The return tuple looks like the following: {MACD, MACD Signal}.
  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex>Talib.BollingerBand.from_list([1, 2, 3, 4, 5, 6], 3, 2)
      {:ok, %Talib.BollingerBand{
        period: 3,
        deviation: 2,
        values: [
        {nil, nil, nil}, 
        {nil, nil, nil}, 
        {3.0, 2.0, 1.0}, 
        {4.6329931618554525, 3.0, 1.367006838144548}, 
        {5.6329931618554525, 4.0, 2.367006838144548}, 
        {6.6329931618554525, 5.0, 3.367006838144548}
        ]
      }}

      iex>Talib.BollingerBand.from_list([], 3, 2)
      {:error, :no_data}
  """
  @spec from_list([number], integer, integer) :: {:ok, Talib.BollingerBand.t}
  | {:error, atom}
  def from_list(data, period \\ 20, deviation \\ 2),
    do: calculate(data, period, deviation)

  @doc """
  Gets the BBand of a list.

  The return tuple looks like the following: {Upper Band, Middle, Lower Band}.
  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex>Talib.BollingerBand.from_list!([1, 2, 3], 3, 2)
      %Talib.BollingerBand{
              deviation: 2,
              period: 3,
              values: [
              {nil, nil, nil}, 
              {nil, nil, nil}, 
              {3.0, 2.0, 1.0}
            ]
      }

      iex>Talib.BollingerBand.from_list!([], 20, 2)
      ** (NoDataError) no data error
  """
  @spec from_list!([number], integer, integer) :: Talib.BBand.t
  | no_return
  def from_list!(data, period \\ 20, deviation \\ 2) do
    case calculate(data, period, deviation) do
      {:ok, result} -> result
      {:error, :no_data} -> raise NoDataError
    end
  end

  defp calculate_bband_point(mid, stddev, deviation) when is_nil(mid) do
    {nil, nil, nil}
  end 

  defp calculate_bband_point(mid, stddev, deviation) when is_nil(stddev) do
    {nil, nil, nil}
  end

  defp calculate_bband_point(mid, stddev, deviation) when is_float(stddev) and is_float(mid) do
    band = (stddev * deviation)
    {mid + band, mid, mid - band}
  end

  defp calculate_bband_point(mid, stddev_series, deviation) when is_list(stddev_series) do
    stddev = Average.deviation!(stddev_series)
    calculate_bband_point(mid, stddev, deviation)
  end

  @doc false
  @spec calculate([number], integer, integer) :: {:ok, Talib.BollingerBand.t}
  | {:error, atom}
  defp calculate(data, period, deviation) do
    OK.with do
      %SMA{values: middle_band} <- SMA.from_list(data, period)
      
      append_length = data
      |> length
      |> rem(period)
      |> (fn x -> Kernel.-(period, x) end).()

      append_list = Stream.cycle([nil])
      |> Enum.take(append_length)
      
      shaped_data = append_list ++ data

      bband = Enum.chunk_every(shaped_data, period, 1)
      |> Enum.zip(middle_band)
      |> Enum.map(fn({series, m}) -> calculate_bband_point(m, series, deviation) end)

      {:ok, %Talib.BollingerBand{
        period: period,
        deviation: deviation,
        values: bband,
      }}
    else
      :no_data -> {:error, :no_data}
    end
  end
end
