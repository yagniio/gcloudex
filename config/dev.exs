use Mix.Config

config :goth, 
  json: if File.exists?("config/creds.json") do 
          "config/creds.json" |> Path.expand |> File.read!
        else
          "config/creds_test.json" |> Path.expand |> File.read!
        end

config :logger,
  level: :debug