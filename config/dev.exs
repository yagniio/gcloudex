use Mix.Config

config :goth, 
  json: "config/creds.json" |> Path.expand |> File.read!

config :logger,
  level: :debug