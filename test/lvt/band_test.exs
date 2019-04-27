defmodule Lvt.BandTest do
  use ExUnit.Case, async: true

  test "members/0" do
    assert Lvt.Band.members() |> length == 5
  end

  test "add_at/2" do
    assert Lvt.Band.add_at(0, "fort") |> hd == "fort"

    # clean up.. probably not the best way
    clean_up
  end

  test "remove_at/1" do
    Lvt.Band.add_at(0, "fort")
    Lvt.Band.remove_at(0)
    assert Lvt.Band.members() |> hd == nil
  end

  test "guitarist/1" do
    Lvt.Band.remove_at(0)
    Lvt.Band.add_at(0, "Freddy")
    assert Lvt.Band.guitarist() == "Freddy"

    clean_up
  end

  test "adding to already taken spot shouldn't add anything" do
    Lvt.Band.add_at(0, "farm-a")
    {:error, "taken"} = Lvt.Band.add_at(0, "farm-b")
  end

  defp clean_up do
    Lvt.Band.remove_at(0)
  end
end
