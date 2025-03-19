defmodule Dishcovery.Repo do
  use Ecto.Repo,
    otp_app: :dishcovery,
    adapter: Ecto.Adapters.Postgres
end
