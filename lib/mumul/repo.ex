defmodule Mumul.Repo do
  use Ecto.Repo,
    otp_app: :mumul,
    adapter: Ecto.Adapters.Postgres
end
