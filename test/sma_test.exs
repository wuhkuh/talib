defmodule Talib.SMATest do
  use ExUnit.Case
  alias Talib.SMA

  doctest Talib.SMA

  defmodule Fixtures do
    def numbers do
      [
        89, 77,  53, 64, 78, 67, 30,  6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, 44, 66, 89
      ]
    end

    def numbers_with_nil do
      [
        89, 77,  53, 64, 78, 67, 30,  6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, nil, 66, 89
      ]
    end

    def numbers_sma_10 do
      [
        nil, nil, nil, nil, nil,
        nil, nil, nil, nil, 54.1,
        49.8, 45.1, 49.8, 48.2, 43.8,
        44.0, 45.0, 48.8, 53.0, 56.6
      ]
    end

    def numbers_sma_10_with_nil do
      [
        nil, nil, nil, nil, nil,
        nil, nil, nil, nil, 54.1,
        49.8, 45.1, 49.8, 48.2, 43.8,
        44.0, 45.0, 49.333333333333336, 
        54.0, 58.0
      ]
    end
  end

  test "from_list/2" do
    assert SMA.from_list(Fixtures.numbers, 10) ==
      {:ok, %Talib.SMA{
        period: 10,
        values: Fixtures.numbers_sma_10
      }}

    assert SMA.from_list(Fixtures.numbers_with_nil, 10) ==
      {:ok, %Talib.SMA{
        period: 10,
        values: Fixtures.numbers_sma_10_with_nil
      }}

    assert SMA.from_list([nil, 87, 77], 2) ==
      {:ok, %Talib.SMA{
        period: 2,
        values: [nil, nil, 82.0]
      }}

    assert SMA.from_list([3], 3) ==
      {:ok, %Talib.SMA{
        period: 3,
        values: [nil]
      }}


    assert SMA.from_list([], 1) === {:error, :no_data}
    assert SMA.from_list([3], 0) === {:error, :bad_period}
  end

  test "from_list!/2" do
    assert SMA.from_list!(Fixtures.numbers, 10) ==
      %Talib.SMA{
        period: 10,
        values: Fixtures.numbers_sma_10
      }

    assert SMA.from_list!([nil, 87, 77], 2) ==
      %Talib.SMA{
        period: 2,
        values: [nil, nil, 82.0]
      }

    assert SMA.from_list!([3], 3) ==
      %Talib.SMA{
        period: 3,
        values: [nil]
      }

    assert_raise NoDataError, fn -> SMA.from_list!([], 1) end
    assert_raise BadPeriodError, fn -> SMA.from_list!([3], 0) end
  end
end
