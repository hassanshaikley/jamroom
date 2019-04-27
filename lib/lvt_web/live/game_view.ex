defmodule LvtWeb.GameView do
  use Phoenix.LiveView
  # use Lvt.Game

  # <%= @guitarist %>

  # <%= if  @guitarist == nil do %>
  # <button phx-click="select-guitar">select-guitar</button>
  #   <% else %>
  #   <button phx-click="un-select-guitar">un-select-guitar</button>
  # <% end %>

  def render(assigns) do
    ~L"""
    <div class="">
      <div>
      You are: <%= @name %>
      <br />
      Guitarist is: <%= @guitarist %>
      <br />

      <%= if @guitarist == nil do %>
      <button phx-click="select-guitar">select-guitar</button>
        <% else %>
        <button phx-click="un-select-guitar">un-select-guitar</button>
      <% end %>

      </div>

      <script>
      </script>
    </div>
    """
  end

  def mount(_session, socket) do
    # May need to unsubscribe on termination
    if connected?(socket), do: Phoenix.PubSub.subscribe(Lvt.InternalPubSub, "game")

    # get_game_state(socket)

    {:ok, assign(socket, name: get_random_name, guitarist: Lvt.Band.guitarist())}
  end

  def handle_event("select-guitar", _value, socket) do
    old_guitarist = Lvt.Band.guitarist()

    new_guitarist = socket.assigns.name

    with idk <- Lvt.Band.add_at(0, new_guitarist) do
      Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})

      {:noreply, assign(socket, guitarist: new_guitarist)}
    else
      err ->
        {:noreply, socket}
    end
  end

  def handle_event("un-select-guitar", _value, socket) do
    Lvt.Band.remove_at(0)
    Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})

    {:noreply, assign(socket, guitarist: nil)}
  end

  # Consume message from pubsub
  def handle_info({:update_game_state}, socket) do
    {:noreply, assign(socket, get_game_state(socket))}
  end

  defp get_random_name do
    "person-#{:rand.uniform(200)}"
  end

  defp get_game_state(socket) do
    guitarist = Lvt.Band.guitarist()

    socket.assigns
    |> Map.put(:guitarist, guitarist)
  end
end
