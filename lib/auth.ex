defmodule GCloudex.Auth do
  alias Goth.Token, as: GoogleAuth

  @moduledoc """
  Provides retrieval of authentication tokens for several Google Cloud Platform
  services' scopes.
  """

  @cloud_scope_cs_read_only   "https://www.googleapis.com/auth/cloud-platform.read-only"
  @cloud_scope_cs             "https://www.googleapis.com/auth/cloud-platform"

  @storage_scope_read_only    "https://www.googleapis.com/auth/devstorage.read_only"
  @storage_scope_read_write   "https://www.googleapis.com/auth/devstorage.read_write"
  @storage_scope_full_control "https://www.googleapis.com/auth/devstorage.full_control"

  @sql_scope_admin            "https://www.googleapis.com/auth/sqlservice.admin"

  @doc """
  Retrieves an authentication token for the Google Cloud Storage service.
  """
  @spec get_token_storage(atom) :: binary
  def get_token_storage(type) do
    case type do
      :read_only ->
        {:ok, get_token_response} =
          GoogleAuth.for_scope @storage_scope_read_only

        get_token_response |> Map.get(:token)

      :read_write ->
        {:ok, get_token_response} =
          GoogleAuth.for_scope @storage_scope_read_write

        get_token_response |> Map.get(:token)

      :full_control ->
        {:ok, get_token_response} =
          GoogleAuth.for_scope @storage_scope_full_control

        get_token_response |> Map.get(:token)

      :sql_admin ->
        {:ok, get_token_response} = 
          GoogleAuth.for_scope @sql_scope_admin

        get_token_response |> Map.get(:token)

      :cs_read_only ->
        {:ok, get_token_response} =
          GoogleAuth.for_scope @cloud_scope_cs_read_only

        get_token_response |> Map.get(:token)

      :cs ->
        {:ok, get_token_response} = GoogleAuth.for_scope @cloud_scope_cs

        get_token_response |> Map.get(:token)
    end
  end
end