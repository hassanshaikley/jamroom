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
      <% end %>

      <%= if is_binary(@strum_guitar)  do %>
        <img src="/images/guitarist_1.png" class="game_img" />
        <div id="<%= @strum_guitar %>">
          <script>
            window.playGuitar && window.playGuitar({chord: "<%= @strum_guitar %>", stroke: 'down'});
          </script>
        </div>
      <% end %>

      <%= if !is_nil(@guitarist) && @strum_guitar == false do  %>
        <img src="/images/guitarist_2.png" class="game_img" />
      <% end %>


      <%= if @guitarist == @name do %>
        <div>
          <div phx-keydown="guitar-keydown" phx-target="window"> </div>
          <button phx-click="un-select-guitar">un-select-guitar</button>
        </div>
      <% end %>

      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    # May need to unsubscribe on termination
    if connected?(socket), do: Phoenix.PubSub.subscribe(Lvt.InternalPubSub, "game")

    {:ok,
     assign(socket, name: get_random_name, guitarist: Lvt.Band.guitarist(), strum_guitar: nil)}
  end

  def terminate(_reason, socket) do
    # GameManager.Manager.leave_seat(socket.id)
    Lvt.Band.members()
    |> Enum.find_index(fn x -> x == socket.assigns.name end)
    |> Lvt.Band.remove_at()

    # Also need to set strum_guitar to nil again
    # strum_guitar: nil

    Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})
  end

  def handle_event("select-guitar", _value, socket) do
    old_guitarist = Lvt.Band.guitarist()

    maybe_new_guitarist = socket.assigns.name

    with idk <- Lvt.Band.add_at(0, maybe_new_guitarist) do
      Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})

      {:noreply, assign(socket, guitarist: maybe_new_guitarist, strum_guitar: false)}
    else
      err ->
        {:noreply, socket}
    end
  end

  def handle_event("guitar-keydown", key, socket) do
    possible_chords = ["a", "b", "c", "d", "e", "f", "g"]

    if Enum.member?(possible_chords, key) do
      Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:play_sound, :guitar, key})

      :timer.apply_after(
        100,
        Phoenix.PubSub,
        :broadcast,
        [Lvt.InternalPubSub, "game", {:stop_sound, :guitar}]
      )
    end

    {:noreply, socket}
  end

  def handle_event("un-select-guitar", _value, socket) do
    Lvt.Band.remove_at(0)
    Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})

    {:noreply, assign(socket, guitarist: nil, strum_guitar: false)}
  end

  def handle_info({:update_game_state}, socket) do
    {:noreply, assign(socket, get_game_state(socket))}
  end

  def handle_info({:play_sound, guitar, chord}, socket) do
    {:noreply, assign(socket, strum_guitar: chord)}
  end

  def handle_info({:stop_sound, guitar}, socket) do
    {:noreply, assign(socket, strum_guitar: false)}
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
