defmodule Talib.UtilityTest do
  use ExUnit.Case
  doctest Talib.Utility

  alias Talib.Utility

  defmodule Fixtures do
    def numbers do
      [
        89, 77, 53, 64, 78, 67, 30, 6, 24, 53,
        46, 30, 100, 48, 34, 69, 40, 44, 66, 89
      ]
    end

    def numbers_change do
      [
      -12, -24, 11, 14, -11, -37, -24, 18, 29,
      -7, -16, 70, -52, -14, 35, -29, 4, 22, 23
      ]
    end

    def numbers_gain do
      [
        0, 0, 11, 14, 0, 0, 0, 18, 29,
        0, 0, 70, 0, 0, 35, 0, 4, 22, 23
      ]
    end
    def numbers_loss do
      [
        12, 24, 0, 0, 11, 37, 24, 0, 0,
        7, 16, 0, 52, 14, 0, 29, 0, 0, 0
      ]
    end

    def numbers_high, do: 100
    def numbers_low, do: 6

    def numbers_occur do
      %{
        89 => 2, 77 => 1, 53 => 2, 64 => 1, 78 => 1, 67 => 1, 30 => 2,
        6 => 1, 24 => 1, 46 => 1, 100 => 1, 48 => 1, 34 => 1, 69 => 1,
        40 => 1, 44 => 1, 66 => 1
      }
    end
  end

  test "high returns the highest value" do
    assert Utility.high(Fixtures.numbers) === Fixtures.numbers_high
  end

  test "high returns nil when the list is empty" do
    assert Utility.high([]) === nil
  end

  test "high returns the number when the list is 1 number long" do
    assert Utility.high([3]) == 3
  end

  test "low returns the lowest value" do
    assert Utility.low(Fixtures.numbers) === Fixtures.numbers_low
  end

  test "low returns nil when the list is empty" do
    assert Utility.low([]) === nil
  end

  test "low returns the number when the list is 1 number long" do
    assert Utility.low([3]) == 3
  end

  test "change returns the change in the list" do
    assert Utility.change(Fixtures.numbers) === Fixtures.numbers_change
  end

  test "change returns nil when the list is empty" do
    assert Utility.change([]) === nil
  end

  test "change returns nil when the list is 1 number long" do
    assert Utility.change([3]) === nil
  end

  test "gain returns the gain in the list" do
    assert Utility.gain(Fixtures.numbers) === Fixtures.numbers_gain
  end

  test "gain returns nil when the list is empty" do
    assert Utility.gain([]) === nil
  end

  test "gain returns nil when the list is 1 number long" do
    assert Utility.gain([3]) === nil
  end

  test "loss returns the loss in the list" do
    assert Utility.loss(Fixtures.numbers) === Fixtures.numbers_loss
  end
  
  test "loss returns nil when the list is empty" do
    assert Utility.loss([]) === nil
  end

  test "loss returns nil when the list is 1 number long" do
    assert Utility.loss([3]) === nil
  end

  test "occur returns a map with element occurance of a list" do
    assert Utility.occur(Fixtures.numbers) === Fixtures.numbers_occur
  end

  test "occur returns nil when the list is empty" do
    assert Utility.occur([]) === nil
  end
end
