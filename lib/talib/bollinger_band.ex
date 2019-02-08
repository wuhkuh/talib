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

      iex>Talib.BollingeBand.from_list([1, 2, 3, 4, 5, 6], 3, 2)
      {:ok, %Talib.MACD{
        long_period: 26,
        short_period: 12,
        signal_period: 9,
        values: [
          {0.0, 1.0},
          {0.07977207977207978, 1.2000000000000002},
          {0.22113456871291648, 1.5600000000000003}
        ]
      }}

      iex>Talib.MACD.from_list([], 26, 12, 9)
      {:error, :no_data}
  """
  @spec from_list([number], integer, integer) :: {:ok, Talib.BollingerBand.t}
  | {:error, atom}
  def from_list(data, period \\ 20, deviation \\ 2),
    do: calculate(data, period, deviation)

  @doc """
  Gets the MACD of a list.

  The return tuple looks like the following: {MACD, MACD Signal}.
  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex>Talib.MACD.from_list!([1, 2, 3], 26, 12, 9)
      {:ok,
        %Talib.BollingerBand{
          deviation: 2,
          period: 3,
          values: [
            {nil, nil, nil},
            {nil, nil, nil},
            {3.632993161855452, 2.0, 0.36700683814454793},
            {4.6329931618554525, 3.0, 1.367006838144548},
            {5.0, 4.0, 3.0}
          ]
        }
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
      bband = Enum.chunk_every(data, period, 1)
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
