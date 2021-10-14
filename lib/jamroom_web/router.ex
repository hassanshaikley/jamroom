defmodule JamroomWeb.Router do
  use JamroomWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :fetch_live_flash
    plug :put_root_layout, {JamroomWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JamroomWeb do
    pipe_through :browser

    live "/", GameView
  end

  # Other scopes may use custom stacks.
  # scope "/api", JamroomWeb do
  #   pipe_through :api
  # end
end
