defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "simple addition" do
    assert Calc.eval("2 + 3") == 5
    assert Calc.eval("1 + ( 3 + 4 )") == 8
    assert Calc.eval("( 3 + 4 ) + 1") == 8
  end

  test "simple subtraction" do
    assert Calc.eval("2 - 3") == -1
    assert Calc.eval("1 - ( 3 - 4 )") == 2
    assert Calc.eval("( 4 - 3 ) - 1") == 0
  end

  test "simple multiplication" do
    assert Calc.eval("2 * 3") == 6
    assert Calc.eval("3 * ( 4 * 1 )") == 12
    assert Calc.eval("5 * 5") == 25
  end

  test "simple division" do
    assert Calc.eval("4 / 2") == 2
    assert Calc.eval("16 / ( 8 / 2 )") == 4
    assert Calc.eval("( 12 / 3 ) / 2") == 2
  end

  test "other tests" do
    assert Calc.eval("( 2 + 2 ) * 4") == 16
    assert Calc.eval("( 5 + 5 ) / 2") == 5
    assert Calc.eval("( 3 + 3 ) - 6") == 0
    assert Calc.eval("( 4 + ( 6 * 2 ) + 5 ) * 2 ") == 42
  end
end
