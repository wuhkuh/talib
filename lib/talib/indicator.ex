# TODO: Stochastic
defmodule Talib.Indicator do
  alias Talib.MovingAverage
  alias Talib.Utility

  @moduledoc ~S"""
  Module containing indicator functions, such as the RSI.
  """

  @doc """
  Gets the MACD of a list.

  Version: 1.0  
  Source: http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:moving_average_convergence_divergence_macd  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec macd([number], integer, integer, integer) :: [number, ...] | nil
  def macd(data, long_period \\ 26, short_period \\ 12, signal_period \\ 9),
    do: calculate_macd(data, long_period, short_period, signal_period)

  @spec calculate_macd([number], integer, integer, integer) ::
  [{number, number}, ...] | nil
  defp calculate_macd([], _long, _short, _signal), do: nil
  defp calculate_macd(_data, 0, _short, _signal), do: nil
  defp calculate_macd(_data, _long, 0, _signal), do: nil
  defp calculate_macd(_data, _long, _short, 0), do: nil
  defp calculate_macd(data, long, short, signal)
      when length(data) < long or
           length(data) < short or
           length(data) < signal do
    nil
  end

  defp calculate_macd(data, long, short, signal) do
    long_ema = MovingAverage.exponential(data, long)
    short_ema = MovingAverage.exponential(data, short)
    signal_ema = MovingAverage.exponential(data, signal)

    short_long_ema = Enum.zip([long_ema, short_ema, signal_ema])

    for {long_average, short_average, signal_average} <- short_long_ema do
      {short_average - long_average, signal_average}
    end
  end

  @doc """
  Gets the RSI of a list.

  Version: 1.0  
  Source: http://stockcharts.com/school/doku.php?id=chart_school:technical_indicators:relative_strength_index_rsi  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec rsi([number], integer) :: [number, ...] | nil
  def rsi(data, period \\ 14), do: calculate_rsi(data, period)

  @spec calculate_rsi([number], integer) :: [number, ...] | nil
  def calculate_rsi(data, period) when length(data) <= period, do: nil
  def calculate_rsi(_data, 0), do: nil
  def calculate_rsi(data, period) do
    avg_gain = data
    |> Utility.gain
    |> MovingAverage.smoothed(period)

    avg_loss = data
    |> Utility.loss
    |> MovingAverage.smoothed(period)

    avg_gain_loss = Enum.zip(avg_gain, avg_loss)

    for {average_gain, average_loss} <- avg_gain_loss do
      relative_strength = case average_loss do
        0 -> 100
        _ -> average_gain / average_loss
      end

      100 - 100 / (relative_strength + 1)
    end
  end
end
