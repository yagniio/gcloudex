defmodule GCloudex.CloudSQL.Request do
  alias HTTPoison, as: HTTP
  alias GCloudex.Auth, as: Auth

  @moduledoc """
  
  """

  @project_id Application.get_env(:goth, :json) |> Poison.decode! |> Map.get("project_id")
  @endpoint   "https://www.googleapis.com/sql/v1beta4/projects/#{@project_id}/instances"

  def request(verb, headers \\ [], body \\ "") do 
    HTTP.request(
      verb,
      @endpoint,
      body,
      headers ++ [{"x-goog-project-id", @project_id},
                  {"Authorization", "Bearer #{Auth.get_token_storage(:sql_admin)}"}],
      []
      )
  end

  def request_query(verb, headers \\ [], body \\ "", parameters) do 
    HTTP.request(
      verb,
      @endpoint <> "/" <> parameters,
      body,
      headers ++ [{"x-goog-project-id", @project_id},
                  {"Authorization", "Bearer #{Auth.get_token_storage(:sql_admin)}"}],
      []
      )
  end

end