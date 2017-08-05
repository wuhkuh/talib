defmodule Talib.IndicatorTest do
  use ExUnit.Case
  alias Talib.Indicator

  doctest Talib.Indicator

  defmodule Fixtures do
    def numbers do
      [
        89, 77,  53, 64, 78, 67, 30,  6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, 44, 66, 89
      ]
    end

    def numbers_rsi_2 do
      [
        0.0000000000000000, 37.931034482758620,
        68.421052631578950, 38.613861386138610,
        9.8236775818639900, 4.9935979513444270,
        45.320560058953575, 76.906318082788670,
        60.136286201022145, 30.115783059110300,
        86.981496197071180, 39.376933592344780,
        30.414003889969436, 67.454191033138400,
        35.840108267425265, 43.185617779672240,
        74.853807047725820, 88.387636740431600
      ]
    end

    def numbers_rsi_14 do
      [
        41.887905604719760, 47.702675107208490,
        43.792631047660260, 44.468749897255890,
        48.162132406610610, 51.773428242757800
      ]
    end
  end

  # Relative Strength Index

  test "rsi returns the relative strength index with period 14" do
    assert Indicator.rsi(Fixtures.numbers, 14) == Fixtures.numbers_rsi_14
  end

  test "rsi returns the relative strength index with period 2" do
    assert Indicator.rsi(Fixtures.numbers, 2) == Fixtures.numbers_rsi_2
  end

  test "rsi returns nil when the list is empty" do
    assert Indicator.rsi([], 1) === nil
  end

  test "rsi returns nil when the period is 0" do
    assert Indicator.rsi(Fixtures.numbers, 0) === nil
  end

  test "rsi returns nil when the list is smaller than the period" do
    assert Indicator.rsi(Fixtures.numbers, 21) === nil
  end
end