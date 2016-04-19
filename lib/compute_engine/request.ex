defmodule GCloudex.ComputeEngine.Request do
  alias HTTPoison, as: HTTP
  alias HTTPoison.HTTPResponse
  alias GCloudex.Auth, as: Auth

  @moduledoc """
  
  """

  def request(verb, endpoint, headers \\ [], body \\ "") do 
    HTTP.request(
      verb,
      endpoint,
      body,
      headers ++ [{"x-goog-project-id", @project_id},
                  {"Authorization", "Bearer #{Auth.get_token_storage(:compute_read_only)}"}],
      []
      )
  end

  def request_query(verb, endpoint, headers \\ [], body \\ "", parameters) do 
    HTTP.request(
      verb,
      endpoint <> "/" <> parameters,
      body,
      headers ++ [{"x-goog-project-id", @project_id},
                  {"Authorization", "Bearer #{Auth.get_token_storage(:compute_read_only)}"}],
      []
      )
  end
end