defmodule GCloudex.CloudSQL.Request do
  alias HTTPoison, as: HTTP
  alias GCloudex.Auth, as: Auth

  @moduledoc """
  
  """

  @project_id GCloudex.get_project_id

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