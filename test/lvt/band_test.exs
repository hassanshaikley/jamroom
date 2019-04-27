defmodule Lvt.BandTest do
  use ExUnit.Case, async: true

  setup do
    band = start_supervised!(Lvt.Band)
    %{band: band}
  end

  test "length of 5", %{band: band} do
    assert Lvt.Band.members() |> length == 5
  end

  test "add_at", %{band: band} do
    assert Lvt.Band.add_at(0, "fort") |> hd == "fort"
  end

  test "adding to already taken spot shouldn't add anything", %{band: band} do
    Lvt.Band.add_at(0, "farm-a")
    {:error, "taken"} = Lvt.Band.add_at(0, "farm-b")
  end
end
