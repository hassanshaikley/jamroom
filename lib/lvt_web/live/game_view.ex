defmodule LvtWeb.GameView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="">
      <div>
        <%= @amirdy %>
      </div>
      <button phx-click="select-guitar">select-guitar</button>

      <script>
      </script>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, amirdy: "Nah!")}
  end

  def handle_event("select-guitar", _value, socket) do
    # do the deploy process
    Lvt.Band.add_at(0, "player-a")
    {:noreply, assign(socket, amirdy: "Taken")}
  end
end
