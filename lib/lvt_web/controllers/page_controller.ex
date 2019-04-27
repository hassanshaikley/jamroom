defmodule LvtWeb.PageController do
  use LvtWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    # render(conn, "index.html")
    # render(conn, Lvt.GameView)
    LiveView.Controller.live_render(conn, LvtWeb.GameView, session: %{})
  end
end
