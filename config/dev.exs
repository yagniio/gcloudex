use Mix.Config

config :gcloudex,
  storage_proj:  "330132837690"

 config :goth, 
  json: "config/creds.json" |> Path.expand |> File.read!
