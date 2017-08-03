defmodule Talib.MovingAverageTest do
  use ExUnit.Case
  doctest Talib.MovingAverage

  alias Talib.MovingAverage

  defmodule Fixtures do
    def numbers do
      [
        89, 77, 53, 64, 78, 67, 30, 6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, 44, 66, 89
      ]
    end

    def numbers_cma do
      [
        {1, 89 / 01},   {2, 166 / 02},  {3, 219 / 03},   {4, 283 / 04},
        {5, 361 / 05},  {6, 428 / 06},  {7, 458 / 07},   {8, 464 / 08},
        {9, 488 / 09},  {10, 541 / 10}, {11, 587 / 11},  {12, 617 / 12},
        {13, 717 / 13}, {14, 765 / 14}, {15, 799 / 15},  {16, 868 / 16},
        {17, 908 / 17}, {18, 952 / 18}, {19, 1018 / 19}, {20, 1107 / 20}
      ]
    end

    def numbers_ema_10 do
      [
        89.000000000000000, 86.81818181818181,
        80.669421487603300, 77.63861758076634,
        77.704323475172460, 75.75808284332292,
        67.438431417264210, 56.26780752321617,
        50.400933428085950, 50.87349098661578,
        49.987401716322000, 46.35332867699072,
        56.107268917537866, 54.63322002344007,
        50.881725473723684, 54.17595720577392,
        51.598510441087750, 50.21696308816270,
        53.086606163042205, 59.61631413339816
      ]
    end

    def numbers_sma_2 do
      [
        83, 65, 58.5, 71, 72.5, 48.5, 18, 15, 38.5,
        49.5, 38, 65, 74, 41, 51.5, 54.5, 42, 55, 77.5
      ]
    end

    def numbers_sma_20 do
      [55.35]
    end
  end

  # Cumulative Moving Average

  test "cma returns the cumulative moving average" do
    assert MovingAverage.cumulative(Fixtures.numbers) == Fixtures.numbers_cma
  end

  test "cma returns the cumulative moving average with pre-existing average" do
    average = {10, 2387 / 100}
    expected = [
      {11, 29.790909090909096}, {12, 33.725000000000000},
      {13, 35.207692307692310}, {14, 37.264285714285720},
      {15, 39.980000000000004}, {16, 41.668750000000000},
      {17, 40.982352941176470}, {18, 39.038888888888890},
      {19, 38.247368421052634}, {20, 38.985000000000000},
      {21, 39.319047619047620}, {22, 38.895454545454550},
      {23, 41.552173913043480}, {24, 41.820833333333330},
      {25, 41.508000000000000}, {26, 42.565384615384616},
      {27, 42.470370370370375}, {28, 42.525000000000000},
      {29, 43.334482758620695}, {30, 44.856666666666670}
    ]

    assert MovingAverage.cumulative(average, Fixtures.numbers) == expected
  end

  test "cma returns nil when the list is empty" do
    assert MovingAverage.cumulative([]) === nil
  end

  test "cma returns nil when the list is empty with pre-existing average" do
    assert MovingAverage.cumulative(1, 2, []) == [{1, 2}]
  end

  test "cma returns nil when the list is empty without pre-existing average" do
    assert MovingAverage.cumulative(0, 0, []) === nil
  end

  # Exponential Moving Average

  test "ema returns the exponential moving average" do
    assert MovingAverage.exponential(10, Fixtures.numbers) ==
    Fixtures.numbers_ema_10
  end

  test "ema returns nil when the list is empty" do
    assert MovingAverage.exponential(10, []) === nil
  end

  # Simple Moving Average

  test "sma returns the simple moving average with period 20" do
    assert MovingAverage.simple(20, Fixtures.numbers) == Fixtures.numbers_sma_20
  end

  test "sma returns the simple moving average with period 2" do
    assert MovingAverage.simple(2, Fixtures.numbers) == Fixtures.numbers_sma_2
  end

  test "sma returns nil when the list is empty" do
    assert MovingAverage.simple(1, []) === nil
  end
end
