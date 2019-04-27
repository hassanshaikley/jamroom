defmodule Lvt.Band do
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

  def members() do
    GenServer.call(__MODULE__, {:members})
  end

  def handle_call({:add_at, index, new_member}, _from, members) do
    case Enum.at(members, index) do
      nil ->
        updated_members = List.replace_at(members, index, new_member)
        {:reply, updated_members, updated_members}

      _ ->
        {:reply, {:error, "taken"}, members}
    end
  end

  def handle_call({:members}, _from, members) do
    {:reply, members, members}
  end
end
