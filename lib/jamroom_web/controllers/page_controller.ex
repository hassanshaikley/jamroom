defmodule JamroomWeb.PageController do
  use JamroomWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    # render(conn, "index.html")
    # render(conn, Jamroom.GameView)
    LiveView.Controller.live_render(conn, JamroomWeb.GameView, session: %{})
  end
end
