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

  def remove_at(nil) do
  end

  def remove_at(index) do
    GenServer.call(__MODULE__, {:add_at, index, nil})
  end

  def members() do
    GenServer.call(__MODULE__, {:members})
  end

  def guitarist() do
    GenServer.call(__MODULE__, {:members}) |> Enum.at(0)
  end

  def drummer() do
    GenServer.call(__MODULE__, {:members}) |> Enum.at(1)
  end

  def handle_call({:add_at, index, new_member}, _from, members) do
    already_a_member = Enum.find(members, fn x -> x == new_member end) |> is_binary

    IO.puts("ADDA T")

    case Enum.at(members, index) do
      _ when already_a_member ->
        {:reply, {:error, "alreadyamember"}, members}

      _ when is_nil(new_member) ->
        updated_members = List.replace_at(members, index, new_member)
        {:reply, updated_members, updated_members}

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
