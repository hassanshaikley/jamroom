defmodule Jamroom.Repo do
  use Ecto.Repo,
    otp_app: :jamroom,
    adapter: Ecto.Adapters.Postgres
end
