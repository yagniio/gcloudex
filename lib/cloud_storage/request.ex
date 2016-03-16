defmodule GCloudex.CloudStorage.Request do
  alias HTTPoison, as: HTTP
  alias GCloudex.Auth, as: Auth

  @moduledoc """
  
  """

  @endpoint "storage.googleapis.com"
  @project  Application.get_env(:gcloudex, :storage_proj)

  def request_service do 
    HTTP.request(
      :get,
      @endpoint,
      "",
      [
        {"x-goog-project-id", @project},
        {"Authorization", "Bearer #{Auth.get_token_storage(:full_control)}"}
      ],
      []
    )
  end

  def request(verb, bucket, headers \\ [], body \\ "") do 
    HTTP.request(
      verb,
      bucket <> "." <> @endpoint,
      body,
      headers ++ [{"Authorization", "Bearer #{Auth.get_token_storage(:full_control)}"}],
      []
    )
  end

  def request_query(verb, bucket, headers \\ [], body \\ "", parameters) do 
    HTTP.request(
      verb, 
      bucket <> "." <> @endpoint <> "/" <> parameters,
      body,
      headers ++ [{"Authorization", "Bearer #{Auth.get_token_storage(:full_control)}"}],
      []
    )
  end
end
