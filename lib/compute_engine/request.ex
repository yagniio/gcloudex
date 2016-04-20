defmodule GCloudex.ComputeEngine.Request do
  alias HTTPoison, as: HTTP
  alias HTTPoison.HTTPResponse
  alias GCloudex.Auth, as: Auth
  require Logger

  @moduledoc """
  
  """

  @project_id   GCloudex.get_project_id

  def request(verb, endpoint, headers \\ [], body \\ "", parameters \\ :empty) do 
    endpoint = endpoint <> "/" <> "?" <> parameters
    Logger.info endpoint
    Logger.info body

    HTTP.request(
      verb,
      endpoint,
      body,
      headers ++ [{"x-goog-project-id", @project_id},
                  {"Authorization", "Bearer #{Auth.get_token_storage(:compute)}"}],
      []
      )
  end

  def request_query(verb, endpoint, headers \\ [], body \\ "", parameters) do 
    Logger.info endpoint <> "/" <> parameters
    Logger.info body

    HTTP.request(
      verb,
      endpoint <> "/" <> parameters,
      body,
      headers ++ [{"x-goog-project-id", @project_id},
                  {"Authorization", "Bearer #{Auth.get_token_storage(:compute)}"}],
      []
      )
  end
end