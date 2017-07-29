defmodule Talib.AverageTest do
  use ExUnit.Case
  doctest Talib.Average

  alias Talib.Average

  defmodule Fixtures do
    def numbers do
      [
        89, 77, 53, 64, 78, 67, 30, 6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, 44, 66, 89
      ]
    end

    def numbers_mean, do: 5535 / 100
    def numbers_median, do: (53 + 46) / 2
    def numbers_mode, do: [30, 53, 89]
    def numbers_midrange, do: (6 + 100) / 2
  end

  test "mean returns the mean" do
    assert Average.mean(Fixtures.numbers) === Fixtures.numbers_mean
  end

  test "median returns the median" do
    assert Average.median(Fixtures.numbers) === Fixtures.numbers_median
  end

  test "mode returns the mode" do
    assert Average.mode(Fixtures.numbers) === Fixtures.numbers_mode
  end

  test "midrange returns the midrange" do
    assert Average.midrange(Fixtures.numbers) === Fixtures.numbers_midrange
  end
end
