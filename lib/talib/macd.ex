defmodule Talib.MACD do
  alias Talib.EMA
  require OK

  @moduledoc ~S"""
  Defines a Moving Average Convergence/Divergence index.

  ## History

  Version: 1.0  
  Source: http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:moving_average_convergence_divergence_macd  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @typedoc """
  Defines a Moving Average Convergence/Divergence index.

  * :long_period - The long period of the MACD
  * :short_period - The short period of the MACD
  * :signal_period - The signal period of the MACD
  * :values - List of values resulting from the calculation
  """
  @type t :: %Talib.MACD{
    long_period: integer,
    short_period: integer,
    signal_period: integer,
    values: [number]
  }
  defstruct [
    long_period: 0,
    short_period: 0,
    signal_period: 0,
    values: []
  ]

  @doc """
  Gets the MACD of a list.

  The return tuple looks like the following: {MACD, MACD Signal}.
  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex>Talib.MACD.from_list([1, 2, 3], 26, 12, 9)
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
  @spec from_list([number], integer, integer, integer) :: {:ok, Talib.MACD.t}
  | {:error, atom}
  def from_list(data, long \\ 26, short \\ 12, signal \\ 9),
    do: calculate(data, long, short, signal)

  @doc """
  Gets the MACD of a list.

  The return tuple looks like the following: {MACD, MACD Signal}.
  Raises `NoDataError` if the given list is an empty list.

  ## Examples

      iex>Talib.MACD.from_list!([1, 2, 3], 26, 12, 9)
      %Talib.MACD{
        long_period: 26,
        short_period: 12,
        signal_period: 9,
        values: [
          {0.0, 1.0},
          {0.07977207977207978, 1.2000000000000002},
          {0.22113456871291648, 1.5600000000000003}
        ]
      }

      iex>Talib.MACD.from_list!([], 26, 12, 9)
      ** (NoDataError) no data error
  """
  @spec from_list!([number], integer, integer, integer) :: Talib.MACD.t
  | no_return
  def from_list!(data, long \\ 26, short \\ 12, signal \\ 9) do
    case calculate(data, long, short, signal) do
      {:ok, macd} -> macd
      {:error, :no_data} -> raise NoDataError
    end
  end

  @doc false
  @spec calculate([number], integer, integer, integer) :: {:ok, Talib.MACD.t}
  | {:error, atom}
  defp calculate(data, long_period, short_period, signal_period) do
    OK.with do
      %EMA{values: long_ema} <- EMA.from_list(data, long_period)
      %EMA{values: short_ema} <- EMA.from_list(data, short_period)
      %EMA{values: signal_ema} <- EMA.from_list(data, signal_period)

      short_long_ema = Enum.zip([long_ema, short_ema, signal_ema])

      result = for {long, short, signal} <- short_long_ema do
        {short - long, signal}
      end

      {:ok, %Talib.MACD{
        long_period: long_period,
        short_period: short_period,
        signal_period: signal_period,
        values: result
      }}
    else
      :no_data -> {:error, :no_data}
    end
  end
end
