defmodule JamroomWeb.GameView do
  use Phoenix.LiveView
  # use Jamroom.Game

  @possible_drum_keys ["1", "2", "3", "4"]
  @possible_guitar_chords ["1", "2", "3", "4", "5", "6", "7"]
  @ms_between_beats 75

  @word "friend"
  def render(assigns) do
    ~L"""
    <div class="">
      <%= JamroomWeb.PageView.render("menu.html", assigns) %>
      <%= JamroomWeb.PageView.render("drummer.html", assigns) %>
      <%= JamroomWeb.PageView.render("guitarist.html", assigns) %>
      <%= JamroomWeb.PageView.render("board.html", assigns) %>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    # May need to unsubscribe on termination
    if connected?(socket), do: Phoenix.PubSub.subscribe(Jamroom.InternalPubSub, "game")

    {:ok,
     assign(socket,
       name: get_random_name,
       player_one: Jamroom.Band.guitarist(),
       strum_guitar: nil,
       player_two: Jamroom.Band.drummer(),
       hit_drum: nil,
       board: Enum.map(0..24, fn x -> "" end)
     )}
  end

  def terminate(_reason, socket) do
    with member_index <-
           Jamroom.Band.members()
           |> Enum.find_index(fn x -> x == socket.assigns.name end) do
      member_index
      |> Jamroom.Band.remove_at()
    end

    Phoenix.PubSub.broadcast(Jamroom.InternalPubSub, "game", {:update_game_state})
  end

  def handle_event("select-guitar", _value, socket) do
    old_guitarist = Jamroom.Band.guitarist()

    maybe_new_guitarist = socket.assigns.name

    with idk <- Jamroom.Band.add_at(0, maybe_new_guitarist) do
      Phoenix.PubSub.broadcast(Jamroom.InternalPubSub, "game", {:update_game_state})
      {:noreply, assign(socket, player_one: maybe_new_guitarist, strum_guitar: nil)}
    else
      err ->
        {:noreply, socket}
    end
  end

  def handle_event("guitar-keydown", key, socket) do
    if Enum.member?(@possible_guitar_chords, key) do
      Phoenix.PubSub.broadcast(Jamroom.InternalPubSub, "game", {:play_sound, :guitar, key})

      :timer.apply_after(
        100,
        Phoenix.PubSub,
        :broadcast,
        [Jamroom.InternalPubSub, "game", {:stop_sound, :guitar}]
      )
    end

    {:noreply, socket}
  end

  def handle_event("un-select-guitar", _value, socket) do
    Jamroom.Band.remove_at(0)
    Phoenix.PubSub.broadcast(Jamroom.InternalPubSub, "game", {:update_game_state})

    {:noreply, assign(socket, strum_guitar: nil)}
  end

  def handle_event("select-drum", _value, socket) do
    old_drummer = Jamroom.Band.drummer()

    maybe_new_drummer = socket.assigns.name

    with idk <- Jamroom.Band.add_at(1, maybe_new_drummer) do
      Phoenix.PubSub.broadcast(Jamroom.InternalPubSub, "game", {:update_game_state})
      {:noreply, assign(socket, hit_drum: nil)}
    else
      err ->
        {:noreply, socket}
    end
  end

  def handle_event("drum-keydown", key, socket) do
    if Enum.member?(@possible_drum_keys, key) do
      Phoenix.PubSub.broadcast(Jamroom.InternalPubSub, "game", {:play_sound, :drum, key})

      :timer.apply_after(
        100,
        Phoenix.PubSub,
        :broadcast,
        [Jamroom.InternalPubSub, "game", {:stop_sound, :drum}]
      )
    end

    {:noreply, socket}
  end

  def handle_event("un-select-drum", _value, socket) do
    Jamroom.Band.remove_at(1)
    Phoenix.PubSub.broadcast(Jamroom.InternalPubSub, "game", {:update_game_state})

    {:noreply, assign(socket, player_two: nil, hit_drum: nil)}
  end

  def handle_info({:update_game_state}, socket) do
    {:noreply, assign(socket, get_game_state(socket))}
  end

  # we want time to be kept by this function otherwise everyone will get a headache lol
  # it also helps mask latency
  def synchronize_sound() do
    time = :os.system_time(:millisecond)
    time_string = Integer.to_string(time)
    ms_string = String.slice(time_string, -3..-1)
    {ms, _} = Integer.parse(ms_string)
    remainder = rem(ms, @ms_between_beats)
    sleep_time = @ms_between_beats - remainder
    :timer.sleep(sleep_time)
  end

  def handle_info({:play_sound, :guitar, chord}, socket) do
    synchronize_sound
    {:noreply, assign(socket, strum_guitar: chord)}
  end

  def handle_info({:stop_sound, :guitar}, socket) do
    {:noreply, assign(socket, strum_guitar: nil)}
  end

  def handle_info({:play_sound, :drum, chord}, socket) do
    synchronize_sound
    {:noreply, assign(socket, hit_drum: chord)}
  end

  def handle_info({:stop_sound, :drum}, socket) do
    {:noreply, assign(socket, hit_drum: nil)}
  end

  defp get_random_name do
    names = [
      "cersei",
      "milo",
      "pixel",
      "pharmacy",
      "drake",
      "humanoid",
      "kilogram",
      "area",
      "turkey",
      "tanner"
    ]

    "#{Enum.random(names)}-#{:rand.uniform(200)}"
  end

  defp get_game_state(socket) do
    guitarist = Jamroom.Band.guitarist()
    drummer = Jamroom.Band.drummer()

    socket.assigns
    |> Map.put(:player_one, guitarist)
    |> Map.put(:player_two, drummer)
  end
end
