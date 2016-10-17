defmodule DataIngestion do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(DataIngestion.StreamConsumer, [])
    ]

    opts = [strategy: :one_for_one, name: DataIngestion.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
