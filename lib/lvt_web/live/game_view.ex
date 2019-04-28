defmodule LvtWeb.GameView do
  use Phoenix.LiveView
  # use Lvt.Game

  # <%= #@guitarist %>

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
      <img src="/images/bg.png" class="game_img" />


      <%= if @guitarist == nil do %>
        <div phx-click="select-guitar">
        <img src="/images/no_guitarist.png" class="game_img" />
      </div>

      <% else %>
        <img src="/images/guitarist_1.png" class="game_img" />
        <%= if @guitarist == @name do %>
          <div phx-keydown="guitar-keydown" phx-target="window"> </div>
          <button phx-click="un-select-guitar">un-select-guitar</button>
        <% end %>
      <% end %>

      <%= if @strum_guitar > 0 do %>
        <div id="<%= @strum_guitar %>">
          <script>
            window.playGuitar && window.playGuitar({chord: 'a', stroke: 'down'});
          </script>
        </div>
      <% end %>

      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    # May need to unsubscribe on termination
    if connected?(socket), do: Phoenix.PubSub.subscribe(Lvt.InternalPubSub, "game")

    {:ok, assign(socket, name: get_random_name, guitarist: Lvt.Band.guitarist(), strum_guitar: 0)}
  end

  def terminate(_reason, socket) do
    # GameManager.Manager.leave_seat(socket.id)
    Lvt.Band.members()
    |> Enum.find_index(fn x -> x == socket.assigns.name end)
    |> Lvt.Band.remove_at()

    Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})
  end

  def handle_event("select-guitar", _value, socket) do
    old_guitarist = Lvt.Band.guitarist()

    maybe_new_guitarist = socket.assigns.name

    with idk <- Lvt.Band.add_at(0, maybe_new_guitarist) do
      Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})

      {:noreply, assign(socket, guitarist: maybe_new_guitarist)}
    else
      err ->
        {:noreply, socket}
    end
  end

  def handle_event("guitar-keydown", key, socket) do
    Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:play_sound, :guitar})

    {:noreply, socket}
  end

  def handle_event("un-select-guitar", _value, socket) do
    Lvt.Band.remove_at(0)
    Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})

    {:noreply, assign(socket, guitarist: nil)}
  end

  def handle_info({:update_game_state}, socket) do
    {:noreply, assign(socket, get_game_state(socket))}
  end

  def handle_info({:play_sound, guitar}, socket) do
    {:noreply, assign(socket, strum_guitar: socket.assigns.strum_guitar + 1)}
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
