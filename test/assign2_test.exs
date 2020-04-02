defmodule Assign2Test do
  use ExUnit.Case
  doctest Assign2
  import Assign2

# testSimpleEmpty
	test "tiny empty board" do
    assert readFrom("board 7 4") |>
      print() == "|       | 0 pieces
|       |
|       |
|       |
+-------+
"
  end
	test "larger empty board" do
    assert readFrom("board 8 6") |>
      print() == "|        | 0 pieces
|        |
|        |
|        |
|        |
|        |
+--------+
"
  end
	test "odd-size board with powerups" do
    assert readFrom("board 7 4
powerup 3 3
powerup 2 1") |>
      print() == "|       | 0 pieces
|  x    |
|       |
| x     |
+-------+
"
  end

# testSimpleEvenWidth
	test "podium" do
    assert readFrom("board 8 6
dice 6 1
moves") |>
      print() == "|   p    | 1 piece
|  ppp   |
|        |
|        |
|        |
|        |
+--------+
"
  end
	test "podium rotated" do
    assert readFrom("board 8 6
dice 6 2
moves") |>
      print() == "|   p    | 1 piece
|   pp   |
|   p    |
|        |
|        |
|        |
+--------+
"
  end
	test "green piece" do
    assert readFrom("board 8 6
dice 3 1
moves") |>
      print() == "|   gg   | 1 piece
|  gg    |
|        |
|        |
|        |
|        |
+--------+
"
  end
	test "green rotated" do
    assert readFrom("board 8 6
dice 3 2
moves ") |>
      print() == "|   g    | 1 piece
|   gg   |
|    g   |
|        |
|        |
|        |
+--------+
"
  end
	test "upside-down green - can't rotate" do
    assert readFrom("board 8 6
dice 3 3
moves R") |>
      print() == "|   gg   | 1 piece
|  gg    |
|        |
|        |
|        |
|        |
+--------+
"
  end
	test "green can rotate" do
    assert readFrom("board 8 6
dice 3 1
moves R") |>
      print() == "|   g    | 1 piece
|   gg   |
|    g   |
|        |
|        |
|        |
+--------+
"
  end
	test "2 pieces" do
    assert readFrom("board 8 10
dice 1 2 7 2 2
moves +") |>
      print() == "|   c    | 2 pieces
|   c    |
|   c    |
|   c    |
|        |
|        |
|        |
|        |
|   yy   |
|   yy   |
+--------+
"
  end
	test "cyan unrotated" do
    assert readFrom("board 8 10
dice 1 1 7 1 2
moves +") |>
      print() == "|  cccc  | 2 pieces
|        |
|        |
|        |
|        |
|        |
|        |
|        |
|   yy   |
|   yy   |
+--------+
"
  end
	test "3 pieces" do
    assert readFrom("board 8 10
dice 1 2 7 2 2
moves ++") |>
      print() == "|  rr    | 3 pieces
|   rr   |
|        |
|        |
|   c    |
|   c    |
|   c    |
|   c    |
|   yy   |
|   yy   |
+--------+
"
  end
	test "2 pieces with powerup" do
    assert readFrom("board 8 10
powerup 2 9
dice 1 2 7 2 2
moves ll ll
moves +..") |>
      print() == "|        | 2 pieces
| x      |
|   c    |
|   c    |
|   c    |
|   c    |
|        |
|        |
|yy      |
|yy      |
+--------+
"
  end
	test "2 pieces with powerup hidden" do
    assert readFrom("board 8 10
powerup 2 9
dice 1 2 7 2 2
moves ll ll
moves +ll.") |>
      print() == "|        | 2 pieces
| c      |
| c      |
| c      |
| c      |
|        |
|        |
|        |
|yy      |
|yy      |
+--------+
"
  end

# testSimpleOddWidth
	test "odd green" do
    assert readFrom("board 7 6
dice 3 1
moves") |>
      print() == "|   gg  | 1 piece
|  gg   |
|       |
|       |
|       |
|       |
+-------+
"
  end
	test "odd green rotated" do
    assert readFrom("board 7 6
dice 3 2
moves ") |>
      print() == "|   g   | 1 piece
|   gg  |
|    g  |
|       |
|       |
|       |
+-------+
"
  end
	test "odd 2 pieces" do
    assert readFrom("board 7 10
dice 1 2 7 2 2
moves +") |>
      print() == "|   c   | 2 pieces
|   c   |
|   c   |
|   c   |
|       |
|       |
|       |
|       |
|   yy  |
|   yy  |
+-------+
"
  end
	test "odd 2 cyan horizontal" do
    assert readFrom("board 7 10
dice 1 1 7 1 2
moves +") |>
      print() == "|  cccc | 2 pieces
|       |
|       |
|       |
|       |
|       |
|       |
|       |
|   yy  |
|   yy  |
+-------+
"
  end
	test "odd 3 pieces" do
    assert readFrom("board 7 10
dice 1 2 7 2 2
moves ++") |>
      print() == "|  rr   | 3 pieces
|   rr  |
|       |
|       |
|   c   |
|   c   |
|   c   |
|   c   |
|   yy  |
|   yy  |
+-------+
"
  end

# testMultipiece
	test "4 pieces" do
    assert readFrom("board 7 10
dice 3 1 2 1 7 2
moves +++++++++++") |>
      print() == "|   gg  | 4 pieces
|  gg   |
|   c   |
|   c   |
|   c   |
|   c   |
|  rr   |
|   rr  |
|   gg  |
|  gg   |
+-------+
"
  end
	test "20 pieces" do
    assert readFrom("board 8 10
dice 7 2
moves r+ rr+ rrr+ rrrr+ l+ ll+ lll+ Rrrrrr+ rrrr+ rrrr+ rrrr+ rrrr+ + Rllll+ lll+ ll+ l+  +++++++") |>
      print() == "|        | 20 pieces
|        |
|   c    |
|   c    |
|   c    |
|   c    |
|   c    |
|   c    |
|   c    |
|   c    |
+--------+
"
  end
	test "14 pieces" do
    assert readFrom("board 8 10
dice 7 2
powerup 3 7
moves r+ rr+ rrr+ rrrr+ l+ ll+ lll+ l....r +Rrrrr+lll+ll+l++++") |>
      print() == "|   c    | 14 pieces
|   c    |
|   c    |
|  xc    |
|   c    |
|   c    |
|   c    |
|cccc    |
|cccc    |
|cccc    |
+--------+
"
  end

  test "1 rot y" do
    assert readFrom("board 8 10
dice 1 1
moves") |>
      print() == "|   yy   | 1 piece
|   yy   |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
+--------+
"
  end

  test "2 rot y" do
    assert readFrom("board 8 10
dice 1 1
moves") |>
      print() == "|   yy   | 1 piece
|   yy   |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
+--------+
"
  end

  test "3 rot y" do
    assert readFrom("board 8 10
dice 1 1
moves") |>
      print() == "|   yy   | 1 piece
|   yy   |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
+--------+
"
  end
  test "4 rot y" do
    assert readFrom("board 8 10
dice 1 1
moves") |>
      print() == "|   yy   | 1 piece
|   yy   |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
|        |
+--------+
"
  end

  test "right" do
    assert readFrom("board 7 8
dice 1 1
moves r r r") |>
      print() ==
"|     yy| 1 piece
|     yy|
|       |
|       |
|       |
|       |
|       |
|       |
+-------+
"
  end

  test "left" do
    assert readFrom("board 7 8
dice 1 1
moves l l l l l") |>
      print() ==
"|yy     | 1 piece
|yy     |
|       |
|       |
|       |
|       |
|       |
|       |
+-------+
"
end

test "left2" do
  assert readFrom("board 7 8
dice 6 2
moves l ll L") |>
    print() ==
"|p      | 1 piece
|pp     |
|p      |
|       |
|       |
|       |
|       |
|       |
+-------+
"
end

test "rotationR2" do
  assert readFrom("board 6 4
dice 2 2
moves") |>
    print() ==
"|   r  | 1 piece
|  rr  |
|  r   |
|      |
+------+
"
end
end
