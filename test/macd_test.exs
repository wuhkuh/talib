defmodule Talib.MCDATest do
  use ExUnit.Case
  alias Talib.MACD

  doctest Talib.MACD

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
  end

  test "from_list/4" do
    assert MACD.from_list(Fixtures.numbers, 2, 3, 4) ==
      {:ok, %Talib.MACD{
        long_period: 2,
        short_period: 3,
        signal_period: 4,
        values: Fixtures.numbers_macd_2_3_4
      }}

    assert MACD.from_list([3], 3, 2, 1) ==
      {:ok, %Talib.MACD{
        long_period: 3,
        short_period: 2,
        signal_period: 1,
        values: [{0.0, 3.0}]
      }}

    assert MACD.from_list([1]) ==
      {:ok, %Talib.MACD{
        long_period: 26,
        short_period: 12,
        signal_period: 9,
        values: [{0.0, 1.0}]
      }}

    assert MACD.from_list([]) === {:error, :no_data}
  end

  test "from_list!/4" do
    assert MACD.from_list!(Fixtures.numbers, 2, 3, 4) ==
      %Talib.MACD{
        long_period: 2,
        short_period: 3,
        signal_period: 4,
        values: Fixtures.numbers_macd_2_3_4
      }

    assert MACD.from_list!([3], 3, 2, 1) ==
      %Talib.MACD{
        long_period: 3,
        short_period: 2,
        signal_period: 1,
        values: [{0.0, 3.0}]
      }

    assert MACD.from_list!([1]) ==
      %Talib.MACD{
        long_period: 26,
        short_period: 12,
        signal_period: 9,
        values: [{0.0, 1.0}]
      }

    assert_raise NoDataError, fn -> MACD.from_list!([]) end
  end
end
