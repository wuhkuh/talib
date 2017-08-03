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

  @spec cumulative([number]) :: [{integer, number}, ...] | nil
  def cumulative([]), do: nil
  def cumulative(data), do: cumulative(0, 0, data)

  @spec cumulative({integer, number}, [number]) ::
  [{integer, number}, ...] |
  nil
  def cumulative({weight, average}, data), do: cumulative(weight, average, data)

  @spec cumulative(integer, number, [number]) :: [{integer, number}, ...] | nil
  def cumulative(0, _average, []), do: nil
  def cumulative(weight, average, data) do
    calculate_cumulative(weight, average, data)
  end

  @spec calculate_cumulative(integer, number, [number], [{integer, number}]) ::
        [{integer, number}, ...]
  defp calculate_cumulative(weight, average, data, results \\ [])
  defp calculate_cumulative(weight, average, [], []), do: [{weight, average}]
  defp calculate_cumulative(weight, average, [hd | tl], results)
      when is_integer(weight) do
    new_weight = weight + 1
    new_average = (average * weight + hd) / new_weight
    # Weight is the weight of the input average

    case tl do
      [_ | _] ->
        new_results = results ++ [{new_weight, new_average}]
        calculate_cumulative(new_weight, new_average, tl, new_results)
      [] ->
        results ++ [{new_weight, new_average}]
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

  @spec exponential(integer, [number]) :: [number] | nil
  def exponential(_period, []), do: nil
  def exponential(period, data), do: calculate_exponential(period, data)

  @spec calculate_exponential(integer, [number], [number]) :: [number]
  defp calculate_exponential(period, [hd | tl], results \\ [])
      when is_integer(period) do
    previous_avg =
      case results do
        [] ->
          hd
        [_ | _] ->
          [result] = Enum.take(results, -1)
          result
      end

    new_weight = 2 / (period + 1)
    new_average = hd * new_weight + previous_avg * (1 - new_weight)

    case tl do
      [_ | _] -> calculate_exponential(period, tl, results ++ [new_average])
      [] -> results ++ [new_average]
    end
  end

  @doc """
  Gets the simple moving average of a list.

  Version: 1.0  
  Source: https://qkdb.wordpress.com/2013/04/22/simple-moving-average/  
  Audited by:

  | Name         | Title             |
  | :----------- | :---------------- |
  |              |                   |

  """

  @spec simple(integer, [number]) :: [number] | nil
  def simple(period, data), do: calculate_simple(period, data)

  @spec calculate_simple(integer, [number], [number]) :: [number, ...] | nil
  def calculate_simple(_period, _data, results \\ [])
  def calculate_simple(_period, [], []), do: nil
  def calculate_simple(_period, [], results), do: results
  def calculate_simple(period, [_hd | tl] = data, results)
      when is_integer(period) do
    data_length = length(data)

    cond do
      data_length < period ->
        results
      data_length >= period ->
        result = data
        |> Enum.take(period)
        |> Enum.sum
        |> Kernel./(period)

        calculate_simple(period, tl, results ++ [result])
    end
  end
end
