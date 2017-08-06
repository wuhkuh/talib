defmodule Talib.AverageTest do
  use ExUnit.Case
  alias Talib.Average

  doctest Talib.Average

  defmodule Fixtures do
    def numbers do
      [
        89, 77,  53, 64, 78, 67, 30,  6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, 44, 66, 89
      ]
    end

    def numbers_mean, do: 5535 / 100
    def numbers_median, do: (53 + 46) / 2
    def numbers_mode, do: [30, 53, 89]
    def numbers_midrange, do: (6 + 100) / 2
  end

  test "mean/1" do
    assert Average.mean(Fixtures.numbers) == {:ok, Fixtures.numbers_mean}
    assert Average.mean([3]) == {:ok, 3}
    assert Average.mean([]) === {:error, :no_data}
  end

  test "median/1" do
    assert Average.median(Fixtures.numbers) == {:ok, Fixtures.numbers_median}
    assert Average.median([3]) == {:ok, 3}
    assert Average.median([]) === {:error, :no_data}
  end

  test "midrange/1" do
    assert Average.midrange(Fixtures.numbers) == {:ok, Fixtures.numbers_midrange}
    assert Average.midrange([3]) == {:ok, 3}
    assert Average.midrange([]) === {:error, :no_data}
    
  end

  test "mode/1" do
    assert Average.mode(Fixtures.numbers) == {:ok, Fixtures.numbers_mode}
    assert Average.mode([3]) == {:ok, 3}
    assert Average.mode([]) === {:error, :no_data}
  end

  test "mean!/1" do
    assert Average.mean!(Fixtures.numbers) == Fixtures.numbers_mean
    assert Average.mean!([3]) == 3
    assert_raise NoDataError, fn -> Average.mean!([]) end
  end

  test "median!/1" do
    assert Average.median!(Fixtures.numbers) == Fixtures.numbers_median
    assert Average.median!([3]) == 3
    assert_raise NoDataError, fn -> Average.median!([]) end
  end

  test "midrange!/1" do
    assert Average.midrange!(Fixtures.numbers) == Fixtures.numbers_midrange
    assert Average.midrange!([3]) == 3
    assert_raise NoDataError, fn -> Average.midrange!([]) end
    
  end

  test "mode!/1" do
    assert Average.mode!(Fixtures.numbers) == Fixtures.numbers_mode
    assert Average.mode!([3]) == 3
    assert_raise NoDataError, fn -> Average.mode!([]) end
  end
end
