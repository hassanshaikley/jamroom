defmodule Jamroom.BoardTest do
  use ExUnit.Case, async: true
  alias Jamroom.Board

  test "members/0" do
    assert Board.members() |> length == 5
  end

  test "add_at/2" do
    assert Board.add_at(0, "fort") |> hd == "fort"
    clean_up
  end

  test "add_at/2 cannot have same object in two places" do
    assert Board.add_at(0, "fort") |> hd == "fort"
    {:error, _} = Board.add_at(1, "fort")

    clean_up
  end

  test "remove_at/1" do
    Board.add_at(0, "fort")
    Board.remove_at(0)
    assert Board.members() |> hd == nil
  end

  test "remove_at/1 handles nil" do
    Board.remove_at(nil)
  end

  test "guitarist/1" do
    Board.remove_at(0)
    Board.add_at(0, "Freddy")
    assert Board.guitarist() == "Freddy"

    clean_up
  end

  test "adding to already taken spot shouldn't add anything" do
    Board.add_at(0, "farm-a")
    {:error, "taken"} = Board.add_at(0, "farm-b")
  end

  defp clean_up do
    Board.remove_at(0)
  end
end
