defmodule Talib.BollingerBandTest do
  use ExUnit.Case
  alias Talib.BollingerBand

  doctest Talib.BollingerBand

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
        46, 30, 100, 48, 34, 69, nil, 40, 44, 66,
        89
      ]
    end

    def numbers_bband_5_2 do
      [{nil, nil, nil},
       {nil, nil, nil}, 
       {nil, nil, nil}, 
       {nil, nil, nil},
       {126.45863986500214, 72.2, 17.941360134997858}, 
       {110.97406628984581, 67.8, 24.625933710154193}, 
       {91.63612492454558, 58.4, 25.163875075454413}, 
       {82.23612492454558, 49.0, 15.763875075454422}, 
       {94.6596682807488, 41.0, -12.65966828074881}, 
       {83.18643872978761, 36.0, -11.18643872978761}, 
       {82.10467175123996, 31.8, -18.504671751239965}, 
       {83.40465095318444, 31.8, -19.80465095318444}, 
       {98.63998334720777, 50.6, 2.5600166527922283}, 
       {79.26629422428208, 55.4, 31.533705775717923}, 
       {79.98591199873627, 51.6, 23.214088001263725}, 
       {91.99050153322807, 56.2, 20.409498466771943}, 
       {97.35035121170691, 58.2, 19.049648788293105}]
    end
    def numbers_bband_5_2_with_nil do
      [{nil, nil, nil}, 
       {nil, nil, nil}, 
       {nil, nil, nil}, 
       {nil, nil, nil}, 
       {126.45863986500214, 72.2, 17.941360134997858}, 
       {110.97406628984581, 67.8, 24.625933710154193}, 
       {91.63612492454558, 58.4, 25.163875075454413}, 
       {82.23612492454558, 49.0, 15.763875075454422}, 
       {94.6596682807488, 41.0, -12.65966828074881}, 
       {83.18643872978761, 36.0, -11.18643872978761}, 
       {82.10467175123996, 31.8, -18.504671751239965}, 
       {83.40465095318444, 31.8, -19.80465095318444}, 
       {100.30663939555761, 50.6, 0.8933606044423925}, 
       {81.8716829838981, 55.4, 28.928317016101904}, 
       {78.25989497353656, 51.6, 24.94010502646344}, 
       {81.94393132371201, 56.2, 30.456068676288}, 
       {101.90035121170689, 62.75, 23.599648788293102}, 
       {86.90035121170689, 47.75, 8.599648788293102}]
    end
  end

  test "from_list/4" do
    assert BollingerBand.from_list(Fixtures.numbers, 5, 2) ==
      {:ok, %Talib.BollingerBand{
        period: 5,
        deviation: 2,
        values: Fixtures.numbers_bband_5_2
      }}

    assert BollingerBand.from_list(Fixtures.numbers_with_nil, 5, 2) ==
      {:ok, %Talib.BollingerBand{
        period: 5,
        deviation: 2,
        values: Fixtures.numbers_bband_5_2_with_nil
      }}
    
    assert BollingerBand.from_list([3], 3, 2) ==
      {:ok, %Talib.BollingerBand{
        period: 3,
        deviation: 2,
        values: [{nil, nil, nil}]
      }}

    assert BollingerBand.from_list([1]) ==
      {:ok, %Talib.BollingerBand{
        period: 20,
        deviation: 2,
        values: [{nil, nil, nil}]
      }}

    assert BollingerBand.from_list([]) === {:error, :no_data}
  end
end
