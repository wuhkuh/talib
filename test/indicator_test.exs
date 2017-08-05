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

    def numbers_macd_2_3_4 do
      [
        {  0.00000000000000000, 89.00000000000000000},
        {  2.00000000000000000, 84.20000000000000000},
        {  5.66666666666667100, 71.72000000000000000},
        {  2.55555555555555700, 68.63200000000000000},
        { -1.14814814814815240, 72.37920000000000000},
        {  0.45061728395062060, 70.22752000000000000},
        {  6.73353909465020450, 54.13651199999999600},
        {  9.53617969821673500, 34.88190719999999000},
        {  3.82455989940557830, 30.52914431999999700},
        { -3.23556336686480250, 39.51748659200000000},
        { -2.16706278895493650, 42.11049195520000400},
        {  1.40004157034834980, 37.26629517312000000},
        {-10.13878822655054500, 62.35977710387200000},
        { -0.01566378385018652, 56.61586626232320000},
        {  4.01007821788327600, 47.56951975739392000},
        { -2.48899085445557940, 56.14171185443635000},
        {  2.09082791830647350, 49.68502711266181000},
        {  1.49052174099799120, 47.41101626759708400},
        { -2.77303653555275530, 54.84660976055825000},
        { -6.39261740312696250, 68.50796585633495000}
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

  # Moving Average Convergence Divergence

  test "macd returns the macd with long 2, short 3 and signal 4" do
    assert Indicator.macd(Fixtures.numbers, 2, 3, 4) == Fixtures.numbers_macd_2_3_4
  end

  test "macd returns nil when the list is empty" do
    assert Indicator.macd([], 1) === nil
  end

  test "macd returns nil when the period is 0" do
    assert Indicator.macd(Fixtures.numbers, 0) === nil
  end

  test "macd returns nil when the list is smaller than the long period" do
    assert Indicator.macd(Fixtures.numbers, 21) === nil
  end

  test "macd returns nil when the list is smaller than the short period" do
    assert Indicator.macd(Fixtures.numbers, 1, 21) === nil
  end

  test "macd returns nil when the list is smaller than the signal period" do
    assert Indicator.macd(Fixtures.numbers, 1, 1, 21) === nil
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