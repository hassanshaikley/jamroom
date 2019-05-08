defmodule Jamroom.BandTest do
  use ExUnit.Case, async: true

  test "members/0" do
    assert Jamroom.Band.members() |> length == 5
  end

  test "add_at/2" do
    assert Jamroom.Band.add_at(0, "fort") |> hd == "fort"
    clean_up
  end

  test "add_at/2 cannot have same object in two places" do
    assert Jamroom.Band.add_at(0, "fort") |> hd == "fort"
    {:error, _} = Jamroom.Band.add_at(1, "fort")

    clean_up
  end

  test "remove_at/1" do
    Jamroom.Band.add_at(0, "fort")
    Jamroom.Band.remove_at(0)
    assert Jamroom.Band.members() |> hd == nil
  end

  test "remove_at/1 handles nil" do
    Jamroom.Band.remove_at(nil)
  end

  test "guitarist/1" do
    Jamroom.Band.remove_at(0)
    Jamroom.Band.add_at(0, "Freddy")
    assert Jamroom.Band.guitarist() == "Freddy"

    clean_up
  end

  test "adding to already taken spot shouldn't add anything" do
    Jamroom.Band.add_at(0, "farm-a")
    {:error, "taken"} = Jamroom.Band.add_at(0, "farm-b")
  end

  defp clean_up do
    Jamroom.Band.remove_at(0)
  end
end
