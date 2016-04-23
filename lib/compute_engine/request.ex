defmodule GCloudex.ComputeEngine.Request do
  alias GCloudex.Auth, as: Auth
  use GCloudex.ComputeEngine, :client
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

    Logger.info "Host:" <> endpoint
    Logger.info "Body:" <> body

    HTTPoison.request(
      verb,
      endpoint,
      body,
      headers ++ [{"x-goog-project-id", @project_id},
                  {"Authorization", "Bearer #{Auth.get_token_storage(:compute)}"}],
      []
      )
  end
end