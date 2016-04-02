defmodule GCloudex.CloudSQL.Request do
  alias HTTPoison, as: HTTP
  alias GCloudex.Auth, as: Auth

  @moduledoc """
  Offers HTTP requests to be used in by the Google Cloud SQL wrapper.
  """

  @project_id GCloudex.get_project_id

  @doc """
  Sends a HTTP request with the given 'verb', 'headers' and 'body' to the 
  specified 'endpoint'. The authorization and google project headers are 
  added automatically.
  """
  @spec request(atom, binary, list, binary) :: {:ok, HTTPoison.Response.t | HTTPoison.AsyncResponse.t} | {:error, HTTPoison.Error.t}
  def request(verb, endpoint, headers \\ [], body \\ "") do 
    HTTP.request(
      verb,
      endpoint,
      body,
      headers ++ [{"x-goog-project-id", @project_id},
                  {"Authorization", "Bearer #{Auth.get_token_storage(:sql_admin)}"}],
      []
      )
  end

  @doc """
  Sends a HTTP request with the given 'verb', 'headers', 'body' and query
  'parameters' to the specified 'endpoint'. The authorization and google 
  project headers are added automatically.
  """
  @spec request_query(atom, binary, list, binary, binary) :: {:ok, HTTPoison.Response.t | HTTPoison.AsyncResponse.t} | {:error, HTTPoison.Error.t}
  def request_query(verb, endpoint, headers \\ [], body \\ "", parameters) do 
    HTTP.request(
      verb,
      endpoint <> "/" <> parameters,
      body,
      headers ++ [{"x-goog-project-id", @project_id},
                  {"Authorization", "Bearer #{Auth.get_token_storage(:sql_admin)}"}],
      []
      )
  end
end