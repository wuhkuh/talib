# TODO: Weighted Moving Average
defmodule Talib.MovingAverage do
  @moduledoc ~S"""
  Module containing moving average functions, such as the
  CMA, EMA and SMA.
  """

  @doc """
  Gets the cumulative moving average of a list.

  Version: 1.0  
  Source: https://qkdb.wordpress.com/tag/cumulative-moving-average/  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec cumulative([number]) :: [{number, integer}, ...] | nil
  def cumulative([]), do: nil
  def cumulative(data), do: cumulative(0, 0, data)

  @spec cumulative({number, integer}, [number]) ::
  [{number, integer}, ...] |
  nil
  def cumulative({average, weight}, data), do: cumulative(average, weight, data)

  @spec cumulative(number, integer, [number]) :: [{number, integer}, ...] | nil
  def cumulative(_average, 0, []), do: nil
  def cumulative(average, weight, data) do
    calculate_cumulative(average, weight, data)
  end

  @spec calculate_cumulative(number, integer, [number], [{number, integer}]) ::
        [{number, integer}, ...]
  defp calculate_cumulative(average, weight, data, results \\ [])
  defp calculate_cumulative(average, weight, [], []), do: [{average, weight}]
  defp calculate_cumulative(average, weight, [hd | tl], results)
      when is_integer(weight) do
    new_weight = weight + 1
    new_average = (average * weight + hd) / new_weight
    # Weight is the weight of the input average

    case tl do
      [_ | _] ->
        new_results = results ++ [{new_average, new_weight}]
        calculate_cumulative(new_average, new_weight, tl, new_results)
      [] ->
        results ++ [{new_average, new_weight}]
    end
  end

  @doc """
  Gets the exponential moving average of a list.

  Version: 1.0  
  Source: http://www.itl.nist.gov/div898/handbook/pmc/section3/pmc324.htm  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec exponential([number], integer) :: [number] | nil
  def exponential(data, period), do: calculate_exponential(data, period)

  @spec calculate_exponential([number], integer, [number]) :: [number]
  defp calculate_exponential(data, period, results \\ [])
  defp calculate_exponential(_data, 0, _results), do: nil
  defp calculate_exponential([], _period, []), do: nil
  defp calculate_exponential(data, period, []) when length(data) < period,
    do: nil

  defp calculate_exponential([hd | tl], period, []) when is_integer(period) do
    # Initiation
    new_weight = 2 / (period + 1)
    new_average = hd * new_weight + hd * (1 - new_weight)
    
    calculate_exponential(tl, period, [new_average])
  end

  defp calculate_exponential([hd | tl], period, [_ | _] = results) do
    # Propagation
    [previous_average] = Enum.take(results, -1)
    new_weight = 2 / (period + 1)
    new_average = hd * new_weight + previous_average * (1 - new_weight)
    
    calculate_exponential(tl, period, results ++ [new_average])
  end
  
  defp calculate_exponential([], _period, results), do: results
    # Termination

  @doc """
  Gets the simple moving average of a list.

  Version: 1.0  
  Source: https://qkdb.wordpress.com/2013/04/22/simple-moving-average/  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec simple([number], integer) :: [number] | nil
  def simple(data, period), do: calculate_simple(data, period)

  @spec calculate_simple([number], integer, [number]) :: [number, ...] | nil
  defp calculate_simple(_data, _period, results \\ [])
  defp calculate_simple(_data, 0, _results), do: nil
  defp calculate_simple([], _period, []), do: nil
  defp calculate_simple([], _period, results), do: results
  defp calculate_simple([_hd | tl] = data, period, results)
      when is_integer(period) do
    data_length = length(data)

    cond do
      data_length < period && results === [] ->
        nil
      data_length < period ->
        results
      data_length >= period ->
        result = data
        |> Enum.take(period)
        |> Enum.sum
        |> Kernel./(period)

        calculate_simple(tl, period, results ++ [result])
    end
  end

  @doc """
  Gets the smoothed moving average of a list.

  Version: 1.0  
  Source: http://www2.wealth-lab.com/WL5Wiki/SMMA.ashx  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec smoothed([number], integer) :: [number, ...] | nil
  def smoothed(data, period), do: calculate_smoothed(data, period)

  @spec calculate_smoothed([number], integer, [number]) :: [number, ...] | nil
  defp calculate_smoothed(data, period, results \\ [])
  defp calculate_smoothed(_data, _period, nil), do: nil
  defp calculate_smoothed([], _period, []), do: nil
  defp calculate_smoothed(data, period, []) when is_integer(period) do
    # Initiation
    {hd, tl} = Enum.split(data, period)
    result = simple(hd, period)

    calculate_smoothed(tl, period, result)
  end

  defp calculate_smoothed([hd | tl], period, [_ | _] = results) do
    # Propagation
    [previous_average] = Enum.take(results, -1)
    result = (previous_average * (period - 1) + hd) / period

    calculate_smoothed(tl, period, results ++ [result])
  end

  defp calculate_smoothed([], _period, results), do: results
    # Termination
end
