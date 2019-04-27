defmodule Lvt.Repo do
  use Ecto.Repo,
    otp_app: :lvt,
    adapter: Ecto.Adapters.Postgres
end
