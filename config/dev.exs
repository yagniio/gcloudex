use Mix.Config

config :gcloudex,
  project:  "330132837690"

 config :goth, 
  json: "config/creds.json" |> Path.expand |> File.read!

config :logger,
  level: :debug