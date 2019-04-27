defmodule Lvt.Band do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [nil, nil, nil, nil, nil])
  end

  def init(opts) do
    {:ok, opts}
  end

  def add_at(server, index, new_member) do
    GenServer.call(server, {:add_at, index, new_member})
  end

  def members(server) do
    GenServer.call(server, {:members})
  end

  def handle_call({:add_at, index, new_member}, _from, members) do
    updated_members = List.replace_at(members, index, new_member)
    {:reply, updated_members, updated_members}
  end

  def handle_call({:members}, _from, members) do
    {:reply, members, members}
  end
end
