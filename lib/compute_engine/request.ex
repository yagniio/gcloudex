defmodule GCloudex.ComputeEngine.Request do
  alias HTTPoison, as: HTTP
  alias HTTPoison.HTTPResponse
  alias GCloudex.Auth, as: Auth
  require Logger

  @moduledoc """
  
  """

  @doc """
  
  """
  @spec request(atom, binary, [{binary, binary}], binary, binary) :: HTTPResponse.t
  def request(verb, endpoint, headers \\ [], body \\ "", parameters \\ "") do
    endpoint = 
      if parameters == "" do 
        endpoint
      else
        endpoint <> "/" <> "?" <> parameters
      end 

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
end