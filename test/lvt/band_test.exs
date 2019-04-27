defmodule Lvt.BandTest do
  use ExUnit.Case, async: true

  setup do
    band = start_supervised!(Lvt.Band)
    %{band: band}
  end

  test "length of 5", %{band: band} do
    assert Lvt.Band.members(band) |> length == 5
  end

  test "add_at", %{band: band} do
    Lvt.Band.add_at(band, 0, "fort")
  end
end
