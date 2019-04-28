defmodule LvtWeb.GameView do
  use Phoenix.LiveView
  # use Lvt.Game

  # <%= #@guitarist %>

  #       

  def render(assigns) do
    ~L"""
    <div class="">
      <%= LvtWeb.PageView.render("menu.html", assigns) %>
      <img src="/images/bg.png" class="game_img" />
      <%= LvtWeb.PageView.render("guitarist.html", assigns) %>
      <%= LvtWeb.PageView.render("drummer.html", assigns) %>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    # May need to unsubscribe on termination
    if connected?(socket), do: Phoenix.PubSub.subscribe(Lvt.InternalPubSub, "game")

    {:ok,
     assign(socket,
       name: get_random_name,
       guitarist: Lvt.Band.guitarist(),
       strum_guitar: nil,
       drummer: Lvt.Band.drummer(),
       hit_drum: nil
     )}
  end

  def terminate(_reason, socket) do
    with member_index <-
           Lvt.Band.members()
           |> Enum.find_index(fn x -> x == socket.assigns.name end) do
      member_index
      |> Lvt.Band.remove_at()
    end

    Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})
  end

  def handle_event("select-guitar", _value, socket) do
    old_guitarist = Lvt.Band.guitarist()

    maybe_new_guitarist = socket.assigns.name

    with idk <- Lvt.Band.add_at(0, maybe_new_guitarist) do
      Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})
      {:noreply, assign(socket, guitarist: maybe_new_guitarist, strum_guitar: nil)}
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

    {:noreply, assign(socket, guitarist: nil, strum_guitar: nil)}
  end

  def handle_event("select-drum", _value, socket) do
    old_drummer = Lvt.Band.drummer()

    maybe_new_drummer = socket.assigns.name

    with idk <- Lvt.Band.add_at(1, maybe_new_drummer) do
      Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})
      {:noreply, assign(socket, drummer: maybe_new_drummer, hit_drum: nil)}
    else
      err ->
        {:noreply, socket}
    end
  end

  def handle_event("drum-keydown", key, socket) do
    possible_chords = ["s", "h", "k"]

    if Enum.member?(possible_chords, key) do
      Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:play_sound, :drum, key})

      :timer.apply_after(
        100,
        Phoenix.PubSub,
        :broadcast,
        [Lvt.InternalPubSub, "game", {:stop_sound, :drum}]
      )
    end

    {:noreply, socket}
  end

  def handle_event("un-select-drum", _value, socket) do
    Lvt.Band.remove_at(0)
    Phoenix.PubSub.broadcast(Lvt.InternalPubSub, "game", {:update_game_state})

    {:noreply, assign(socket, drummer: nil, hit_drum: nil)}
  end

  def handle_info({:update_game_state}, socket) do
    {:noreply, assign(socket, get_game_state(socket))}
  end

  def handle_info({:play_sound, guitar, chord}, socket) do
    {:noreply, assign(socket, strum_guitar: chord)}
  end

  def handle_info({:stop_sound, guitar}, socket) do
    {:noreply, assign(socket, strum_guitar: nil)}
  end

  def handle_info({:play_sound, drum, chord}, socket) do
    {:noreply, assign(socket, hit_drum: chord)}
  end

  def handle_info({:stop_sound, drum}, socket) do
    {:noreply, assign(socket, hit_drum: nil)}
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
