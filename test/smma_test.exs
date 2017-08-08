defmodule Talib.SMMATest do
  use ExUnit.Case
  alias Talib.SMMA

  doctest Talib.SMMA

  defmodule Fixtures do
    def numbers do
      [
        89, 77,  53, 64, 78, 67, 30,  6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, 44, 66, 89
      ]
    end

    def numbers_smma_2 do
      [
        nil,                83.000000000000000,
        68.000000000000000, 66.000000000000000,
        72.000000000000000, 69.500000000000000,
        49.750000000000000, 27.875000000000000,
        25.937500000000000, 39.468750000000000,
        42.734375000000000, 36.367187500000000,
        68.183593750000000, 58.091796875000000,
        46.045898437500000, 57.522949218750000,
        48.761474609375000, 46.380737304687500,
        56.190368652343750, 72.595184326171880
      ]
    end
  end

  test "from_list/2" do
    assert SMMA.from_list(Fixtures.numbers, 2) ==
      {:ok, %Talib.SMMA{
        period: 2,
        values: Fixtures.numbers_smma_2
      }}

    assert SMMA.from_list([3], 3) ==
      {:ok, %Talib.SMMA{
        period: 3,
        values: [nil]
      }}

    assert SMMA.from_list([], 1) === {:error, :no_data}
    assert SMMA.from_list([3], 0) === {:error, :bad_period}
  end

  test "from_list!/2" do
    assert SMMA.from_list!(Fixtures.numbers, 2) ==
      %Talib.SMMA{
        period: 2,
        values: Fixtures.numbers_smma_2
      }

    assert SMMA.from_list!([3], 3) ==
      %Talib.SMMA{
        period: 3,
        values: [nil]
      }

    assert_raise NoDataError, fn -> SMMA.from_list!([], 1) end
    assert_raise BadPeriodError, fn -> SMMA.from_list!([3], 0) end
  end
end
