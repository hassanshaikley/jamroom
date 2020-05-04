defmodule Jamroom.Board do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [nil, nil, nil, nil, nil], name: __MODULE__)
  end

  def init(opts) do
    {:ok, opts}
  end

  def add_at(index, new_member) do
    GenServer.call(__MODULE__, {:add_at, index, new_member})
  end

  def remove_at(nil) do
  end

  def remove_at(index) do
    GenServer.call(__MODULE__, {:add_at, index, nil})
  end

  def players() do
    GenServer.call(__MODULE__, {:players})
  end

  def guitarist() do
    GenServer.call(__MODULE__, {:players}) |> Enum.at(0)
  end

  def drummer() do
    GenServer.call(__MODULE__, {:players}) |> Enum.at(1)
  end

  def handle_call({:add_at, index, new_member}, _from, players) do
    already_a_member = Enum.find(players, fn x -> x == new_member end) |> is_binary

    case Enum.at(players, index) do
      _ when already_a_member ->
        {:reply, {:error, "alreadyamember"}, players}

      _ when is_nil(new_member) ->
        updated_players = List.replace_at(players, index, new_member)
        {:reply, updated_players, updated_players}

      nil ->
        updated_players = List.replace_at(players, index, new_member)
        {:reply, updated_players, updated_players}

      _ ->
        {:reply, {:error, "taken"}, players}
    end
  end

  def handle_call({:players}, _from, players) do
    {:reply, players, players}
  end
end
