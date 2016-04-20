ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Ws.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Ws.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Ws.Repo)

