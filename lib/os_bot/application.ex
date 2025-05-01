defmodule OsBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application


  # add workers here
  @impl true
  def start(_type, _args) do
    children = [
      OsBot.Consumer,
      OsBot.QueueTracker,
      OsBot.Reorderer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: OsBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
