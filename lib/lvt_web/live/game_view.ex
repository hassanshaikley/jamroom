defmodule LvtWeb.GameView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="">
      <div>
        <%= @amirdy %>
      </div>
      <button phx-click="berdy">Deploy to GitHub</button>

      <script>
      </script>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, amirdy: "Nah!")}
  end

  def handle_event("berdy", _value, socket) do
    # do the deploy process
    {:noreply, assign(socket, amirdy: "READY.!")}
  end
end
