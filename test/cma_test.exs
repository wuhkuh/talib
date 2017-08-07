defmodule Talib.CMATest do
  use ExUnit.Case
  alias Talib.CMA

  doctest Talib.CMA

  defmodule Fixtures do
    def numbers do
      [
        89, 77,  53, 64, 78, 67, 30,  6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, 44, 66, 89
      ]
    end

    def numbers_cma do
      [
        89 / 1, 166 / 2, 219 / 3, 283 / 4, 361 / 5,
        428 / 6, 458 /  7, 464 / 8, 488 / 9, 541 / 10,
        587 / 11, 617 / 12, 717 / 13, 765 / 14, 799 / 15,
        868 / 16, 908 / 17, 952 / 18, 1018 / 19, 1107 / 20
      ]
    end

    def numbers_pre_existing do
      { 2387 / 100, 10 }
    end

    def numbers_pre_existing_cma do
      [
        23.870000000000000, # Pre-existing average
        29.790909090909096, 33.725000000000000,
        35.207692307692310, 37.264285714285720,
        39.980000000000004, 41.668750000000000,
        40.982352941176470, 39.038888888888890,
        38.247368421052634, 38.985000000000000,
        39.319047619047620, 38.895454545454550,
        41.552173913043480, 41.820833333333330,
        41.508000000000000, 42.565384615384616,
        42.470370370370375, 42.525000000000000,
        43.334482758620695, 44.856666666666670
      ]
    end
  end

  test "from_list/1" do
    assert CMA.from_list(Fixtures.numbers) ==
      {:ok, %Talib.CMA{
        prices: Fixtures.numbers,
        values: Fixtures.numbers_cma,
        weight: length(Fixtures.numbers)
      }}

    assert CMA.from_list([3]) ==
      {:ok, %Talib.CMA{
        prices: [3],
        values: [3.0],
        weight: 1
      }}

    assert CMA.from_list([]) === {:error, :no_data}
  end

  test "from_list/3" do
    {average, weight} = Fixtures.numbers_pre_existing

    assert CMA.from_list(Fixtures.numbers, average, weight) ==
      {:ok, %Talib.CMA{
        prices: [average | Fixtures.numbers],
        values: Fixtures.numbers_pre_existing_cma,
        weight: 30
      }}

    assert CMA.from_list([], 2, 1) ==
      {:ok, %Talib.CMA{
        prices: [2],
        values: [2.0],
        weight: 1
      }}

    assert CMA.from_list([], 0, 0) === {:error, :no_data}
  end

  test "from_list!/1" do
    assert CMA.from_list!(Fixtures.numbers) ==
      %Talib.CMA{
        prices: Fixtures.numbers,
        values: Fixtures.numbers_cma,
        weight: length(Fixtures.numbers)
      }

    assert CMA.from_list!([3]) ==
      %Talib.CMA{
        prices: [3],
        values: [3.0],
        weight: 1
      }

    assert_raise NoDataError, fn -> CMA.from_list!([]) end
  end

  test "from_list!/3" do
    {average, weight} = Fixtures.numbers_pre_existing

    assert CMA.from_list!(Fixtures.numbers, average, weight) ==
      %Talib.CMA{
        prices: [average | Fixtures.numbers],
        values: Fixtures.numbers_pre_existing_cma,
        weight: 30
      }

    assert CMA.from_list!([], 2, 1) ==
      %Talib.CMA{
        prices: [2],
        values: [2.0],
        weight: 1
      }

    assert_raise NoDataError, fn -> CMA.from_list!([], 0, 0) end
  end
end
