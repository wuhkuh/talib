defmodule Talib.MovingAverageTest do
  use ExUnit.Case
  alias Talib.MovingAverage

  doctest Talib.MovingAverage

  defmodule Fixtures do
    def numbers do
      [
        89, 77,  53, 64, 78, 67, 30,  6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, 44, 66, 89
      ]
    end

    def numbers_cma do
      [
        { 89 /  1, 1},  {166 /  2,  2}, { 219 /  3,  3}, { 283 /  4,  4},
        {361 /  5, 5},  {428 /  6,  6}, { 458 /  7,  7}, { 464 /  8,  8},
        {488 /  9, 9},  {541 / 10, 10}, { 587 / 11, 11}, { 617 / 12, 12},
        {717 / 13, 13}, {765 / 14, 14}, { 799 / 15, 15}, { 868 / 16, 16},
        {908 / 17, 17}, {952 / 18, 18}, {1018 / 19, 19}, {1107 / 20, 20}
      ]
    end

    def numbers_ema_2 do
      [
        89.000000000000000, 81.000000000000000,
        62.333333333333330, 63.444444444444440,
        73.148148148148150, 69.049382716049380,
        43.016460905349795, 18.338820301783265,
        22.112940100594420, 42.704313366864800,
        44.901437788954940, 34.967145929651650,
        78.322381976550550, 58.107460658850190,
        42.035820219616724, 60.011940073205580,
        46.670646691068530, 44.890215563689510,
        58.963405187896505, 78.987801729298840
      ]
    end

    def numbers_ema_20 do
      [
        89.000000000000000, 87.857142857142850,
        84.537414965986390, 82.581470683511500,
        82.145140142224690, 80.702745842965200,
        75.873912905539950, 69.219254533583770,
        64.912658863718650, 63.778119924316870,
        62.084965645810500, 59.029254631923784,
        62.931230381264380, 61.509208440191580,
        58.889283826840000, 59.852209176664760,
        57.961522588410970, 56.631853770467070,
        57.524058173279730, 60.521766918681660
      ]
    end

    def numbers_sma_2 do
      [
        83.0, 65.0, 58.5, 71.0,
        72.5, 48.5, 18.0, 15.0,
        38.5, 49.5, 38.0, 65.0,
        74.0, 41.0, 51.5, 54.5,
        42.0, 55.0, 77.5
      ]
    end

    def numbers_sma_20 do
      [55.35]
    end

    def numbers_smma_2 do
      [
        83.000000000000000, 68.000000000000000,
        66.000000000000000, 72.000000000000000,
        69.500000000000000, 49.750000000000000,
        27.875000000000000, 25.937500000000000,
        39.468750000000000, 42.734375000000000,
        36.367187500000000, 68.183593750000000,
        58.091796875000000, 46.045898437500000,
        57.522949218750000, 48.761474609375000,
        46.380737304687500, 56.190368652343750,
        72.595184326171880
      ]
    end

    def numbers_smma_20 do
      [55.35]
    end
  end

  # Cumulative Moving Average

  test "cma returns the cumulative moving average" do
    assert MovingAverage.cumulative(Fixtures.numbers) == Fixtures.numbers_cma
  end

  test "cma returns the cumulative moving average with pre-existing average" do
    average = {2387 / 100, 10}
    expected = [
      {29.790909090909096, 11}, {33.725000000000000, 12},
      {35.207692307692310, 13}, {37.264285714285720, 14},
      {39.980000000000004, 15}, {41.668750000000000, 16},
      {40.982352941176470, 17}, {39.038888888888890, 18},
      {38.247368421052634, 19}, {38.985000000000000, 20},
      {39.319047619047620, 21}, {38.895454545454550, 22},
      {41.552173913043480, 23}, {41.820833333333330, 24},
      {41.508000000000000, 25}, {42.565384615384616, 26},
      {42.470370370370375, 27}, {42.525000000000000, 28},
      {43.334482758620695, 29}, {44.856666666666670, 30}
    ]

    assert MovingAverage.cumulative(average, Fixtures.numbers) == expected
  end

  test "cma returns nil when the list is empty" do
    assert MovingAverage.cumulative([]) === nil
  end

  test "cma returns the cma when the list is empty with pre-existing average" do
    assert MovingAverage.cumulative(2, 1, []) == [{2, 1}]
  end

  test "cma returns nil when the list is empty without pre-existing average" do
    assert MovingAverage.cumulative(0, 0, []) === nil
  end

  # Exponential Moving Average

  test "ema returns the exponential moving average with period 20" do
    assert MovingAverage.exponential(Fixtures.numbers, 20) ==
    Fixtures.numbers_ema_20
  end

  test "ema returns the exponential moving average with period 2" do
    assert MovingAverage.exponential(Fixtures.numbers, 2) ==
    Fixtures.numbers_ema_2
  end

  test "ema returns nil when the list is empty" do
    assert MovingAverage.exponential([], 1) === nil
  end

  test "ema returns nil when the period is 0" do
    assert MovingAverage.exponential(Fixtures.numbers, 0) === nil
  end

  test "ema returns nil when the list is smaller than the period" do
    assert MovingAverage.exponential(Fixtures.numbers, 21) === nil
  end

  # Simple Moving Average

  test "sma returns the simple moving average with period 20" do
    assert MovingAverage.simple(Fixtures.numbers, 20) == Fixtures.numbers_sma_20
  end

  test "sma returns the simple moving average with period 2" do
    assert MovingAverage.simple(Fixtures.numbers, 2) == Fixtures.numbers_sma_2
  end

  test "sma returns nil when the list is empty" do
    assert MovingAverage.simple([], 1) === nil
  end

  test "sma returns nil when the period is 0" do
    assert MovingAverage.simple(Fixtures.numbers, 0) === nil
  end

  test "sma returns nil when the list is smaller than the period" do
    assert MovingAverage.simple(Fixtures.numbers, 21) === nil
  end

  # Smoothed Moving Average

  test "smma returns the smoothed moving average with period 20" do
    assert MovingAverage.smoothed(Fixtures.numbers, 20) ==
    Fixtures.numbers_smma_20
  end

  test "smma returns the smoothed moving average with period 2" do
    assert MovingAverage.smoothed(Fixtures.numbers, 2) ==
    Fixtures.numbers_smma_2
  end

  test "smma returns nil when the list is empty" do
    assert MovingAverage.smoothed([], 1) === nil
  end

  test "smma returns nil when the period is 0" do
    assert MovingAverage.smoothed(Fixtures.numbers, 0) === nil
  end

  test "smma returns nil when the list is smaller than the period" do
    assert MovingAverage.smoothed(Fixtures.numbers, 21) === nil
  end
end
